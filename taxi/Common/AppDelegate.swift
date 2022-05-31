//
//  AppDelegate.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 23.05.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
            if #available(iOS 13, *) { } else {
                deleteExpiredObjects()
                self.window = UIWindow()
                let vc = OrdersListController()
                self.window!.rootViewController = vc
                self.window!.makeKeyAndVisible()
                self.window!.backgroundColor = .red
            }
            return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        deleteExpiredObjects()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "taxi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
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
    
    func deleteExpiredObjects() {
        let fetchRequest: NSFetchRequest<VehicleImage> = VehicleImage.fetchRequest()
        let predicate = NSPredicate(format: "expirationDate < %@", Date() as NSDate)
        fetchRequest.predicate = predicate
        
        let context = persistentContainer.viewContext
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        saveContext()
    }

}

