//
//  Item+CoreDataProperties.swift
//  List
//
//  Created by Zebra on 10/13/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> { return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var list: List?

}
