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
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ItemController.sharedController.items.count == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Launch instructions
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        // Checks for first launch, and executes code if not first launch. If first launch, shows launch screen and sets UserDefaults to save status of first launch.
        if launchedBefore == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "welcome")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedController.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        let item = ItemController.sharedController.items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.urlLabel.text = item.url
        
        let (red, green, blue) = calculateColorGradient(row: CGFloat(indexPath.row))
        cell.coloredBoxView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        // Set the big letter as the first letter in Title, else first letter in URL
        if let bigLetter = item.title?.characters.first {
            cell.bigLetterLabel.text = String(bigLetter).capitalized
        } else if let bigLetter = item.url?.characters.first {
            cell.bigLetterLabel.text = String(bigLetter).capitalized
        }
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = ItemController.sharedController.items[(indexPath as NSIndexPath).row]
            
            ItemController.sharedController.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        tableView.reloadData()
        
        if ItemController.sharedController.items.count == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    
    // MARK: - Safari View Controller
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var url = ItemController.sharedController.items[(indexPath as NSIndexPath).row].url
        
        if url!.hasPrefix("http://") == false && url!.hasPrefix("https://") == false {
            url = "http://" + url!
        }
        
        let safariVC = SFSafariViewController(url: URL(string: url!)!)
        
        safariVC.delegate = self
        
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    
    func calculateColorGradient(row: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        // Set the color values in RGB (PINK: [255, 20, 147] ORANGE: [255, 69, 0])
        let colorTopValues: [CGFloat] = [255, 20, 147]
        let colorBottomValues: [CGFloat] = [255, 69, 0]
        
        // Take each RGB value, find out which one is higher
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
        
        let newRedValue = (higherRed - row * (differenceRed / divisor)) / 255
        let newBlueValue = (higherBlue - row * (differenceBlue / divisor)) / 255
        let newGreenValue = (higherGreen - row * (differenceGreen / divisor)) / 255
        
        return (newRedValue, newGreenValue, newBlueValue)
    }
    
    // Right now it figures out which value is lowest, and then adds the numberToAdd to that value. Thus, always stacks the lower value on top/first. What it needs to do instead is find out if the higher value is on top or the lower value is on top. If the higher value is on top, it should subtract the numberToAdd from the higher value. If the lower value is on top it should add the numberToAdd to the lower value.
    func whichNumberIsHigher(_ firstValue: CGFloat, secondValue: CGFloat) -> CGFloat {
        var higherNumber: CGFloat = 0
        
        if firstValue >= secondValue {
            higherNumber = firstValue
        } else {
            higherNumber = secondValue
        }
        
        return higherNumber
    }
    
    
}
