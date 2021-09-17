//
//  APIService.swift
//  URLSessionTutorial-iOS
//
//  Created by kimhyungyu on 2021/09/17.
//

import Foundation

struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}
class APIService {
    static let shared = APIService()
 
    // GET
    func requestGET(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }

        // Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Task
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    // GET query parameter
    func requestGETWithQuery(url: String, query: [String : String], completionHandler: @escaping (Bool, Any) -> Void) {
        // URLComponents 를 사용하면 qery parameter 부분을 URLQueryItem 객체로 쉽게 추가할 수 있다.
        guard var urlComponents = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        
        // query 추가
        let queryItemArray = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents.queryItems = queryItemArray
        
        // URL
        guard let requestURL = urlComponents.url else { return }
        
        // request method 는 기본적으로 GET 이다. 혹시나 POST 등을 사용하고 싶다면 URLRequest 을 만들어야한다.
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "GET"
        
        // Task
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }

    // GET header 에 추가
    func requestGETWithHeader(url: String, headerField: [String : String], completionHandler: @escaping (Bool, Any) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }

        // Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // header 추가
        _ = headerField.map { (key, value) in
            request.addValue(key, forHTTPHeaderField: value)
        }

        // Task
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    // POST - URLSessionDataTask
    func requestPOSTWithURLSessionDataTask(url: String, param: [String : Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let requestBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    // POST - URLSessionUploadTask
    func requestPOSTWithURLSessionUploadTask(url: String, param: [String : Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let uploadData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.uploadTask(with: request, from: uploadData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
}
