//
//  DashBoardViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class DashBoardViewController: BaseViewController {

    @IBOutlet weak var wrapperView: UIView!
    
    private let userId: Int
    
    init(userId: Int) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var leftBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remakeWrapperView(wrapperView)
        setNavigationBarItem(leftBtn)
    }

    @IBAction func didTapGoToListContact(_ sender: UIButton) {
        navigationController?.pushViewController(ContactViewController(), animated: true)
    }
}
