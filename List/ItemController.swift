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
        
        let request = NSFetchRequest(entityName: "Item")
        
        do {
            return try Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as! [Item]
        } catch {
            return []
        }
    }
    
    func addItem(item: Item) {
        saveToPersistentStorage()
    }
    
    func removeItem(item: Item) {
        item.managedObjectContext?.deleteObject(item)
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