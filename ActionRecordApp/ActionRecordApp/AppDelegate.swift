//
//  AppDelegate.swift
//  ActionRecordApp
//
//  Created by Taichi Matsui on 2020/08/25.
//  Copyright © 2020 Taichi Matsui. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //アプリが終了した際にデータを保存するのでここで変数宣言
    var sec = Int()
    var min = Int()
    var hour = Int()
    var startTime = Date()
    var stopTime = Date()
    let time = DateFormatter()
    let date = DateFormatter()
    //インクリメントしていく
    var saveId: Int64 = 0
    //タイマーが動いているかどうか
    var activeTimer: Bool = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //タイマーが動いていたら保存
        if activeTimer {
            
            let managedObjectContext = self.persistentContainer.viewContext
            let record = Record(context: managedObjectContext)
            
            stopTime = Date()

            record.date = date.dateToDate(data: startTime)
            record.startTime = time.string(from: startTime)
            record.stopTime = time.string(from: stopTime)
            record.memo = "アプリ終了時に保存されました"
            record.genreString = "その他"
            record.genre = 9
            record.sec = Int64(sec)
            record.min = Int64(min)
            record.hour = Int64(hour)
           
            record.id = saveId
            saveId += 1
            UserDefaults.standard.set(saveId, forKey: "id")
            
            self.saveContext()
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ActionRecordApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

