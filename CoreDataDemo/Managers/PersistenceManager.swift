//
//  PersistenceManager.swift
//  CoreDataDemo
//
//  Created by Kelvin Fok on 7/12/18.
//  Copyright © 2018 kelvinfok. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager { // Does not allow subclassing with FINAL
    
    private init() {}
    
    static let shared = PersistenceManager()

    lazy var context = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        
        let entityName = String(describing: objectType)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return(fetchedObjects) ?? [T]()
        } catch {
            return [T]()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
