//
//  Stack.swift
//  List
//
//  Created by Zebra on 3/18/16.
//  Copyright © 2016 SimpleSumo. All rights reserved.
//

import Foundation
import CoreData

class Stack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "List")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error._userInfo)")
            }
        })
        return container
    }()
    
//    static var context: NSManagedObjectContext = { return container.viewContext }()
    
    static var context = container.viewContext
    
}

//class Stack {
//    
//    static let sharedStack = Stack()
//    
//    lazy var managedObjectContext: NSManagedObjectContext = Stack.setUpMainContext()
//    
//    static func setUpMainContext() -> NSManagedObjectContext {
//        let bundle = Bundle.main
//        guard let model = NSManagedObjectModel.mergedModel(from: [bundle])
//            else { fatalError("model not found") }
//        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
//        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
//            at: storeURL(), options: nil)
//        let context = NSManagedObjectContext(
//            concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = persistentStoreCoordinator
//        return context
//    }
//    
//    static func storeURL () -> URL? {
//        let documentsDirectory: URL? = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
//        
//        return documentsDirectory?.appendingPathComponent("db.sqlite")
//    }
//    
//}
