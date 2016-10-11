//
//  ItemController.swift
//  List Go 5
//
//  Created by Zebra on 3/17/16.
//  Copyright © 2016 SimpleSumo. All rights reserved.
//

import Foundation
import CoreData

class ItemController  {
    
    static let sharedController = ItemController()
    
    var items: [Item] {
        
        // Added ": NSFetchRequest<NSFetchRequestResult>"
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        
        do {
            return try Stack.sharedStack.managedObjectContext.fetch(request) as! [Item]
        } catch {
            return []
        }
    }
    
    func addItem(_ item: Item) {
        saveToPersistentStorage()
    }
    
    func removeItem(_ item: Item) {
        item.managedObjectContext?.delete(item)
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
     
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved")
        }
        
    }
}
