//
//  AppDelegate.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/24/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = self.window ?? UIWindow()
        window!.backgroundColor = .white
        window!.rootViewController = StringeeViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
}

