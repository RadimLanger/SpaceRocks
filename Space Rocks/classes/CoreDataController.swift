//
//  CoreDataController.swift
//  Space Rocks
//
//  Created by Radim Langer on 06/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataController {

    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Space_Rocks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func retrieve<Entity: NSManagedObject>(
        entityClass: Entity.Type,
        sortBy: String? = nil,
        isAscending: Bool = true,
        predicate: NSPredicate? = nil
        ) -> [Entity] {

        let entityName = String(describing: entityClass)
        let request = NSFetchRequest<Entity>(entityName: entityName)

        request.returnsObjectsAsFaults = false
        request.predicate = predicate

        if (sortBy != nil) {
            let sorter = NSSortDescriptor(key: sortBy, ascending: isAscending)
            request.sortDescriptors = [sorter]
        }

        guard let fetchedResult = try? managedContext.fetch(request) else { return [Entity]() }

        return fetchedResult
    }

    func create<Entity: NSManagedObject>(entityClass: Entity.Type) -> Entity {

        let entityName = String(describing: entityClass)

        guard
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext),
            let object = NSManagedObject(entity: entity, insertInto: managedContext) as? Entity
            else {
                fatalError("coredata failed to create entity")
        }

        return object
    }

    func save() {

        let context = persistentContainer.viewContext

        if context.hasChanges {
            context.performAndWait { // todo: check - has to be done on DispatchQueue.main.
                try? context.save()
            }
        }
    }
}
