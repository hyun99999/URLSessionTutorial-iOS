//
//  ViewController.swift
//  URLSessionTutorial-iOS
//
//  Created by kimhyungyu on 2021/09/16.
//

import UIKit

class ViewController: UIViewController {
    
    let baseURL = "baseURL"
    let parameters = ["name" : "gyu", "familyname" : "kim"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getWithURL(_ sender: Any) {
        APIService.shared.requestGET(url: baseURL) { success, result in
            print(result)
        }
    }
    
    @IBAction func getWithQueryParameter(_ sender: Any) {
        APIService.shared.requestGETWithQuery(url: baseURL, query: parameters) { success, result in
            print(result)
        }
    }
    
    @IBAction func getWithHeader(_ sender: Any) {
        APIService.shared.requestGETWithHeader(url: baseURL, headerField: parameters) { success, result in
            print(result)
        }
    }
    
    @IBAction func postWithURLSessionDataTask(_ sender: Any) {
        APIService.shared.requestPOSTWithURLSessionDataTask(url: baseURL, parameters: parameters) { success, result in
            print(result)
        }
    }
    @IBAction func postWithURLSessionUploadTask(_ sender: Any) {
        APIService.shared.requestPOSTWithURLSessionUploadTask(url: baseURL, parameters: parameters) { success, result in
            print(result)
        }
    }
    @IBAction func postWithMultipartform(_ sender: Any) {
        guard let data = UIImage(systemName: "circle")?.pngData() else { return }
        APIService.shared.requestPOSTWithMultipartform(url: baseURL, parameters: parameters, data: data, filename: "img", mimeType: "image/png") { success, result in
            print(result)
        }
    }
}

