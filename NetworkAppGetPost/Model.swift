//
//  Model.swift
//  NetworkAppGetPost
//
//  Created by Yury on 18.02.23.
//

import Foundation

// MARK: - User
struct User: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let picture: Picture
}



// MARK: - Name
struct Name: Codable {
    let title, first, last: String
    var fullName: String {
        return "\(title) \(first) \(last)"
    }
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
