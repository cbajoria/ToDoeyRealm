//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 25/09/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import  CoreData
import  RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print( NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String)
        do{
            let realm = try Realm()
        }catch
        {
            
        }
        
        
        return true
    }

  
}

