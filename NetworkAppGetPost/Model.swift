//
//  Model.swift
//  NetworkAppGetPost
//
//  Created by Yury on 18.02.23.
//

import Foundation

// MARK: - User
struct User: Codable {
    var results: [Result]
}

// MARK: - Result
struct Result: Codable {
    var name: Name
    var picture: Picture
}



// MARK: - Name
struct Name: Codable {
    var title, first, last: String
    var fullName: String {
        return "\(title) \(first) \(last)"
    }
}

// MARK: - Picture
struct Picture: Codable {
    var large, medium, thumbnail: String
}
