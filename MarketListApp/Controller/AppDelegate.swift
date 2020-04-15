//
//  AppDelegate.swift
//  MarketListApp
//
//  Created by Diego Mieth on 02/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataController = DataController(modelName: "MarketListAppDatabase")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load {
            print("dataController called")
        }
        
        let navigationController = window?.rootViewController as! UINavigationController
        let home = navigationController.topViewController as! HomeVC
        home.dataController = dataController
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        saveModel()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveModel()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveModel()
    }
    func saveModel(){
        do{
            try dataController.viewContext.save()
            print("saved")
        } catch {
            print(error.localizedDescription)
            print("notsaved")
        }
    }

}

