//
//  Item.swift
//  List
//
//  Created by Zebra on 5/24/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

    convenience init(title: String, url: String, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.url = url
    }
}
