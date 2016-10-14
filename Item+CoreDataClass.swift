//
//  Item+CoreDataClass.swift
//  List
//
//  Created by Zebra on 10/13/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {

    convenience init(title: String, url: String, context: NSManagedObjectContext = Stack.context) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.title = title
        self.url = url
    }
    
}
