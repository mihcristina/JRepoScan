//
//  GitHubAPIService.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import RxCocoa
import RxSwift
import UIKit

class GitHubAPIService: GitHubAPIServiceProtocol {
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchRepositoriesRx(page: Int) -> Observable<[Repository]> {
        let urlString = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page=\(page)"
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "URL inválida", code: -1))
        }

        let request = URLRequest(url: url)

        return URLSession.shared.rx.data(request: request)
            .map { [weak self] data in
                guard let self = self else { throw NSError(domain: "Decoder não disponível", code: -1) }
                let response = try self.decoder.decode(GitHubResponse.self, from: data)
                return response.items
            }
    }
    
    func fetchPullRequestsRx(owner: String, repo: String, page: Int) -> Observable<[PullRequest]> {
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/pulls?page=\(page)"
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "URL inválida", code: -1))
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .map { [weak self] data in
                guard let self = self else {
                    throw NSError(domain: "Decoder não disponível", code: -1)
                }
                return try self.decoder.decode([PullRequest].self, from: data)
            }
    }
}
