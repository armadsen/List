//
//  List+Convenience.swift
//  List
//
//  Created by Andrew Madsen on 10/14/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData

extension List {
	// ? Needed to use type NSNumber instead of Int16
	convenience init(name: String, listID: NSNumber, context: NSManagedObjectContext = Stack.context) {
		
		print("\(context)")
		self.init(context: context)
		
		self.name = name
		self.listID = listID
	}
}
