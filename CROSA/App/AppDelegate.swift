//
//  AppDelegate.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/24/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configSlideMenu()
        
        window = self.window ?? UIWindow()
        window!.backgroundColor = .white
        
        let leftMenu = LeftMenuViewController()
        let main = ContactViewController()
        let mainNav = BaseNavigationController(rootViewController: main)
        mainNav.setNavigationBarHidden(true, animated: false)
        let slideMenuController = SlideMenuController(mainViewController: mainNav, leftMenuViewController: leftMenu)
        window!.rootViewController = slideMenuController
        window!.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    fileprivate func configSlideMenu() {
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.animationDuration = 0.27
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width * 0.85
        SlideMenuOptions.contentViewDrag = true
    }
}
