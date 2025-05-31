//
//  GitHubAPIServiceProtocol.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 31/05/25.
//

import RxSwift

protocol GitHubAPIServiceProtocol {
    func fetchRepositoriesRx(page: Int) -> Observable<[Repository]>
    func fetchPullRequestsRx(owner: String, repo: String, page: Int) -> Observable<[PullRequest]>
}
