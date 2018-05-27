//
//  UIViewControllerExtensions.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation

extension UIViewController {
    func message(content: String, title: String, result:(()->())? = nil) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let acOk = UIAlertAction(title: "OK", style: .default) { _ in result?()}
        alert.addAction(acOk)
        present(alert, animated: true, completion: nil)
    }
    
    func message(content: String, title: String, result:@escaping ((Bool)->())) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let acOk = UIAlertAction(title: "OK", style: .default) { _ in result(true)}
        let acCancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in result(false)}
        alert.addAction(acCancel)
        alert.addAction(acOk)
        present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBarItem(_ button: UIButton) {
        button.addTarget(self.slideMenuController(), action: #selector(toggleLeft), for: .touchUpInside)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
}
