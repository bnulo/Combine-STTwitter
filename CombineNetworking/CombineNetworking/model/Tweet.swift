//
//  Tweet.swift
//  CombineNetworking
//
//  Created by bnulo on 1/18/1400 AP.
//

import Foundation

struct Tweet: Codable, Identifiable {
    let text: String
    let user: User
    var id: String { return text }
}

struct User: Codable {
    let name, profileImageUrl: String
}
