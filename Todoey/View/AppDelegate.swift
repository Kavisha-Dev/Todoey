//
//  AppDelegate.swift
//  Todoey
//
//  Created by Kavisha on 14/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Prints the user's app document location
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true));
        
        //Prints the Realm default path
        //print(Realm.Configuration.defaultConfiguration.fileURL);
        
        do {
            let realm = try Realm();
        } catch {
            print("Error initializing realm \(error)")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication){
        print("applicationDidEnterBackground")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
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

