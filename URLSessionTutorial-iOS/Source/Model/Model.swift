//
//  Model.swift
//  URLSessionTutorial-iOS
//
//  Created by kimhyungyu on 2021/09/18.
//

import Foundation

// MARK: - Model
struct Model: Codable {
    let code: Int
    let data: DataClass
    let message: String
}

// MARK: - DataClass
struct DataClass: Codable {
}
