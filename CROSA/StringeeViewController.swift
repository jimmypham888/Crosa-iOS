//
//  StringeeViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/24/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class StringeeViewController: UIViewController {
    
    private var stringeeClient: StringeeClient?
    private let accessToken: String
    @IBOutlet weak var numberField: UITextField!
    
    init() {
        accessToken = ACCESS_TOKEN
        super.init(nibName: "StringeeViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stringeeClient = StringeeClient(connectionDelegate: self)
        stringeeClient?.connect(withAccessToken: accessToken)
    }

    @IBAction func call(_ sender: UIButton) {
        let stringeeCall = StringeeCall(stringeeClient: stringeeClient, from: "84901701061", to: numberField.text)
        stringeeCall?.make(completionHandler: { (status, code, message) in
            print("Make call result: \(code.description), message: \(message?.description ?? "")")
        })
    }
}

extension StringeeViewController: StringeeConnectionDelegate {
    func requestAccessToken(_ stringeeClient: StringeeClient!) {
        print("requestAccessToken")
    }
    
    func didConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("Successfully connected to Stringee Server, user ID: \(stringeeClient.userId)")
    }
    
    func didDisConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("didDisConnect")
    }
    
    func didFailWithError(_ stringeeClient: StringeeClient!, code: Int32, message: String!) {
        print("Failed connection to Stringee Server with error: \(message)")
    }
}
