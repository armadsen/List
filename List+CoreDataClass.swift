//
//  List+CoreDataClass.swift
//  List
//
//  Created by Zebra on 10/13/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData

public class List: NSManagedObject {

    // ? Needed to use type NSNumber instead of Int16
    convenience init(name: String, listID: NSNumber, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "List", in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.name = name
        self.listID = listID
    }

    
}
