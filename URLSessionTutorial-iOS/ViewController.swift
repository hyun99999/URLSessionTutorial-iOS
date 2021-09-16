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
    }

    private func getInfoWithAPI() {
        let defaultSession = URLSession(configuration: .default)

        guard let url = URL(string: "https://test.com") else { return }
    
        // Request
        let request = URLRequest(url: url)

        // Task
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }

            // data 를 처리하는 코드...

        }.resume()
    }

}

