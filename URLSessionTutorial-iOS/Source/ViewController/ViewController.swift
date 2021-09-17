//
//  ViewController.swift
//  URLSessionTutorial-iOS
//
//  Created by kimhyungyu on 2021/09/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        APIService.shared.requestGET(url: "www.test.com") { success, data in
            print("success: \(success)")
            print("data: \(data)")
        }
    }
}

