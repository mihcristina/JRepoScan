//
//  GitHubServiceApiMock.swift
//  JRepoScanTests
//
//  Created by Michelli Cristina de Paulo Lima on 31/05/25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import JRepoScan

class MockGitHubAPIService: GitHubAPIServiceProtocol {
    var mockPullRequests: [PullRequest] = []
    var mockRepositories: [Repository] = []
    
    var shouldFailPRs = false
    var shouldFailRepos = false

    func fetchRepositoriesRx(page: Int) -> Observable<[Repository]> {
        if shouldFailRepos {
            return .error(NSError(domain: "Erro de teste em repositórios", code: -1))
        }
        return .just(mockRepositories)
    }

    func fetchPullRequestsRx(owner: String, repo: String, page: Int) -> Observable<[PullRequest]> {
        if shouldFailPRs {
            return .error(NSError(domain: "Erro de teste em pull requests", code: -1))
        }
        return .just(mockPullRequests)
    }
}
