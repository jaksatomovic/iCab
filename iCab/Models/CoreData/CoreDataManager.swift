//
//  CoreDataManager.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import CoreData

import CoreData

//struct CoreDataManager {
//    
//
//    let persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "CoreDataModels")
//        container.loadPersistentStores { (storeDescription, err) in
//            if let err = err {
//                fatalError("Loading of store failed: \(err)")
//            }
//        }
//        return container
//    }()
//    
//}

class CoreDataManager {
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
