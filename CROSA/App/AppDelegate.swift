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
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = self.window ?? UIWindow()
        window!.backgroundColor = .white
        window!.rootViewController = ContactViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    fileprivate func testContactList() {
        
    }
}
