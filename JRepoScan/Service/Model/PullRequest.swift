//
//  PullRequest.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import Foundation

struct PullRequest: Codable {
    let id: Int
    let title: String
    let htmlUrl: String
    let user: User
    let body: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case htmlUrl = "html_url"
        case user
        case body
        case createdAt = "created_at"
    }
}

struct User: Codable {
    let login: String
}
