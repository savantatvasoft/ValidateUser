//
//  CoreDataManager.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    // Singleton instance to access from anywhere
    static let shared = CoreDataManager()
    
    private init() {}

    // The container that holds the database
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ValidateUser")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // The context used for saving and fetching
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Main save function
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchUserDetails(email: String) -> UserEntity? {
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let results = try context.fetch(fetchRequest)
                return results.first // Returns the specific user object
            } catch {
                print("Error fetching user: \(error)")
                return nil
            }
        }
}
