//
//  AppDelegate.swift
//  CoreDataTest
//
//  Created by Gurpreet Singh on 2021-04-27.
//

import UIKit
import CoreData
import RealmSwift
 
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            let realm = try Realm()
        } catch  {
            print("Error initializing new realm \(error)")
        }
        
        
        return true
    }
 
 
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
 
    }
 
    
    // MARK: - Core Data stack
 // we have this lazily loaded persistent container, so we only get loaded up, once we actually retrieve it or try to use it, and it's basically a new container that we create, that's all the type and it's persistent container, and it's created using the structure that we specified inside our data model, we'd have one entity called item and item has two attributes, a done, and a title. Then we load the persistent store and get it ready for use
    lazy var persistentContainer: NSPersistentContainer = {
 
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
 
    // MARK: - Core Data Saving support
 
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
 
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
}
