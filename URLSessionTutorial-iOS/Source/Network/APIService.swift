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
    func requestPOSTWithURLSessionDataTask(url: String, parameters: [String : Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let requestBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
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
                print("Error occur: error calling POST - \(String(describing: error))")
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
    func requestPOSTWithURLSessionUploadTask(url: String, parameters: [String : String], completionHandler: @escaping (Bool, Any) -> Void) {
        let uploadData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpBody = uploadData
        
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.uploadTask(with: request, from: uploadData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
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
    
    
    // POST - Image 송신
    // data : UIImage 를 pngData() 혹은 jpegData() 사용해서 Data 로 변환한 것.
    // filename : 파일이름(img.jpg 과 같은 이름)
    // mimeType :  타입에 맞게 png면 image/png, text text/plain 등 타입.
    func requestPOSTWithMultipartform(url: String,
                                      parameters: [String : String],
                                      data: Data,
                                      filename: String,
                                      mimeType: String,
                                      completionHandler: @escaping (Bool, Any) -> Void) {
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        // boundary 설정
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // request.httpBody = uploadData
        
        // data
        var uploadData = Data()
        let imgDataKey = "img"
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            uploadData.append(boundaryPrefix.data(using: .utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            uploadData.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        uploadData.append(boundaryPrefix.data(using: .utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        uploadData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        uploadData.append(data)
        uploadData.append("\r\n".data(using: .utf8)!)
        uploadData.append("--\(boundary)--".data(using: .utf8)!)

        
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.uploadTask(with: request, from: uploadData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
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
    
    // POST - Image 수신
    func requestPOSTWithURLSessionDownloadTask(url: String, parameters: [String : String], completionHandler: @escaping (Bool, Any) -> Void) {
        
    }
}
