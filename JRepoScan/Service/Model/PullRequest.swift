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
    let html_url: String
    let user: User
}

struct User: Codable {
    let login: String
}
