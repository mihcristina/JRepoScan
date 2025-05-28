//
//  GitHubAPIService.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class GitHubAPIService {
    func fetchRepositories(page: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let urlString = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page=\(page)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(GitHubResponse.self, from: data)
                completion(.success(decoded.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension GitHubAPIService {
    func fetchPullRequests(owner: String, repo: String, completion: @escaping (Result<[PullRequest], Error>) -> Void) {
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/pulls"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let pulls = try JSONDecoder().decode([PullRequest].self, from: data)
                completion(.success(pulls))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
