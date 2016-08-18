//
//  Item+CoreDataProperties.swift
//  List
//
//  Created by Zebra on 5/24/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var toList: NSManagedObject?

}
