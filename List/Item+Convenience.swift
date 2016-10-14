//
//  Item+Convenience.swift
//  List
//
//  Created by Andrew Madsen on 10/14/16.
//  Copyright © 2016 BradyMower. All rights reserved.
//

import Foundation
import CoreData

extension Item {
	convenience init(title: String, url: String, context: NSManagedObjectContext = Stack.context) {
		
		self.init(context: context)
		
		self.title = title
		self.url = url
	}
}
