//
//  GitHubResponse.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import Foundation

struct GitHubResponse: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let name: String
    let htmlUrl: String
    let stargazersCount: Int
    let owner: Owner
    let forksUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case owner
        case forksUrl = "forks_url"
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
