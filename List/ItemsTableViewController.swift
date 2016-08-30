//
//  ItemsTableViewController.swift
//  List Go 6
//
//  Created by Zebra on 3/4/16.
//  Copyright © 2016 SimpleSumo. All rights reserved.
//

import UIKit
import SafariServices

class ItemsTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ItemController.sharedController.items.count == 0 {
            navigationItem.leftBarButtonItem?.enabled = false
        } else {
            navigationItem.leftBarButtonItem?.enabled = true
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Launch instructions
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("welcome")
            print("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
            presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedController.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = ItemController.sharedController.items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.urlLabel.text = item.url
        
        
    // Calculate color gradient
        
        // Set the color values (PINK: [255, 20, 147] ORANGE: [255, 69, 0])
        let colorTopValues: [CGFloat] = [255, 20, 147] // R G B
        let colorBottomValues: [CGFloat] = [255, 69, 0] // R G B
        
        // Take each RGB value, find out which one is lower
        let higherRed = whichNumberIsHigher(colorTopValues[0], secondValue: colorBottomValues[0])
        let higherBlue = whichNumberIsHigher(colorTopValues[1], secondValue: colorBottomValues[1])
        let higherGreen = whichNumberIsHigher(colorTopValues[2], secondValue: colorBottomValues[2])
        
        // Subtract the two and find the absolute value to get the difference.
        let differenceRed = fabs(colorTopValues[0] - colorBottomValues[0])
        let differenceBlue = fabs(colorTopValues[1] - colorBottomValues[1])
        let differenceGreen = fabs(colorTopValues[2] - colorBottomValues[2])
        
        // Divide that difference by (the number of items in the list - 1)
        // Add (that value * the cellRow) to the lower of the two values and divide by 255
        // That value will be the new value that needs to be the RGB value to use

        var divisor: CGFloat = 1
        let numberOfItems = ItemController.sharedController.items.count
        if numberOfItems > 1 {
            divisor = CGFloat(numberOfItems - 1)
        }
        
        let newRedValue = (higherRed - CGFloat(indexPath.row) * (differenceRed / divisor)) / 255
        let newBlueValue = (higherBlue - CGFloat(indexPath.row) * (differenceBlue / divisor)) / 255
        let newGreenValue = (higherGreen - CGFloat(indexPath.row) * (differenceGreen / divisor)) / 255
        
        // Set the bg color for the coloredView in each cell equal to the calculated RGB value
        cell.coloredBoxView.backgroundColor = UIColor(red: newRedValue, green: newGreenValue, blue: newBlueValue, alpha: 1)
    
        
    // Set the big letter as the first letter in Title, else first letter in URL
        if let bigLetter = item.title?.characters.first {
            cell.bigLetterLabel.text = String(bigLetter).capitalizedString
        } else if let bigLetter = item.url?.characters.first {
            cell.bigLetterLabel.text = String(bigLetter).capitalizedString
        }
        
        return cell
    }
    
    
    // Right now it figures out which value is lowest, and then adds the numberToAdd to that value. Thus, always stacks the lower value on top/first. What it needs to do instead is find out if the higher value is on top or the lower value is on top. If the higher value is on top, it should subtract the numberToAdd from the higher value. If the lower value is on top it should add the numberToAdd to the lower value.
    func whichNumberIsHigher(firstValue: CGFloat, secondValue: CGFloat) -> CGFloat {
        var higherNumber: CGFloat = 0

        if firstValue >= secondValue {
            higherNumber = firstValue
        } else {
            higherNumber = secondValue
        }
        
        return higherNumber
    }
    
    
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let itemToMove = ItemController.sharedController.items[sourceIndexPath.row]
//        ItemController.sharedController.removeItem(itemToMove)
//        ItemController.sharedController.addItem(itemToMove)
//        
//        tableView.reloadData()
//        
//    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let item = ItemController.sharedController.items[indexPath.row]
            
            ItemController.sharedController.removeItem(item)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        tableView.reloadData()
        
        if ItemController.sharedController.items.count == 0 {
            navigationItem.leftBarButtonItem?.enabled = false
        } else {
            navigationItem.leftBarButtonItem?.enabled = true
        }
    }
    
    // MARK: - Safari View Controller
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var url = ItemController.sharedController.items[indexPath.row].url
        
        if url!.hasPrefix("http://") == false && url!.hasPrefix("https://") == false {
            url = "http://".stringByAppendingString(url!)
        }
        
        let safariVC = SFSafariViewController(URL: NSURL(string: url!)!)
        
        safariVC.delegate = self
        
        self.presentViewController(safariVC, animated: true, completion: nil)
    }
    
}
