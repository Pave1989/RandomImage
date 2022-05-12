//
//  AppDelegate.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let assemblyBuilder = AssemblyBuilder()
        let navigationController = UINavigationController(rootViewController: assemblyBuilder.createRandomImageModule())
        
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteImage")
        container.loadPersistentStores(completionHandler:{ storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror)")
            }
        }
    }
}
