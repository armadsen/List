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
        
        // Use provided edit button
        navigationItem.leftBarButtonItem = editButtonItem()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
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

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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

/*
    // Rearranging the table view
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        // Specify which item to remove then insert when reordering - so data can coincide in the array
        let itemToMove = items[fromIndexPath.row]
        items.removeAtIndex(fromIndexPath.row)
        items.insert(itemToMove, atIndex: toIndexPath.row)
    
    }

    // Conditional rearranging of the table view
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
*/

    
    // View clicked cell in Safari View Controller
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Safari View Controller
        
        var url = ItemController.sharedController.items[indexPath.row].url
        
        if url!.hasPrefix("http://") == false && url!.hasPrefix("https://") == false {
            url = "http://".stringByAppendingString(url!)
        }
        
        let safariVC = SFSafariViewController(URL: NSURL(string: url!)!)
        
        safariVC.delegate = self
        
        self.presentViewController(safariVC, animated: true, completion: nil)
        
    }

}
