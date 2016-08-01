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
        
        // Set the color values (either here or up top) RED: [255, 69, 0] ORANGE: [255, 20, 147]
        let colorTopValues: [CGFloat] = [30, 19, 50]
        let colorBottomValues: [CGFloat] = [88, 25, 140]
        
        // Take 2 values, find out which one is lower
        let topRedValue = colorTopValues[0]
        let bottomRedValue = colorBottomValues[0]
        let topBlueValue = colorTopValues[1]
        let bottomBlueValue = colorBottomValues[1]
        let topGreenValue = colorTopValues[2]
        let bottomGreenValue = colorBottomValues[2]
        
        let lowerRed = whichNumberIsLower(topRedValue, secondValue: bottomRedValue)
        let lowerBlue = whichNumberIsLower(topBlueValue, secondValue: bottomBlueValue)
        let lowerGreen = whichNumberIsLower(topGreenValue, secondValue: bottomGreenValue)
        
        // Subtract the two and find the absolute value to get the difference.
        let differenceRed = fabs(topRedValue - bottomRedValue)
        let differenceBlue = fabs(topBlueValue - bottomBlueValue)
        let differenceGreen = fabs(topGreenValue - bottomGreenValue)
        
        // Divide that difference by (the number of items in the list - 1)
        // Add (that value * the cellRow) to the lower of the two values and divide by 255
        var divisor: CGFloat = 1
        let numberOfItems = ItemController.sharedController.items.count
        if numberOfItems > 1 {
            divisor = CGFloat(numberOfItems - 1)
        }
        
        let newRedValue = (lowerRed + CGFloat(indexPath.row) * (differenceRed / divisor)) / 255
        let newBlueValue = (lowerBlue + CGFloat(indexPath.row) * (differenceBlue / divisor)) / 255
        let newGreenValue = (lowerGreen + CGFloat(indexPath.row) * (differenceGreen / divisor)) / 255

        // That value will be the new value that needs to be the RGB value to use
        print("Cell: \(indexPath.row)")
        print("newRed: \(newRedValue)")
        print("newRed: \(newBlueValue)")
        print("newRed: \(newGreenValue)")
        
        // Set the cell bg color equal to the new RGB value
        cell.coloredBoxView.backgroundColor = UIColor(red: newRedValue, green: newGreenValue, blue: newBlueValue, alpha: 1)
        
        if let bigLetter = item.title?.characters.first {
            cell.bigLetterLabel.text = String(bigLetter)
        }
        
        return cell
    }
    
    
    func whichNumberIsLower(firstValue: CGFloat, secondValue: CGFloat) -> CGFloat {
        var lowerNumber: CGFloat = 0

        if firstValue >= secondValue {
            lowerNumber = secondValue
        } else {
            lowerNumber = firstValue
        }
        
        return lowerNumber
    }
    
    
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
