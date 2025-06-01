//
//  PullRequestsViewModelTests.swift
//  JRepoScanTests
//
//  Created by Michelli Cristina de Paulo Lima on 31/05/25.
//

import XCTest
import RxSwift

@testable import JRepoScan

final class PullRequestsViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var viewModel: PullRequestsViewModel!
    var mockService: MockGitHubAPIService!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mockService = MockGitHubAPIService()
        let dummyRepo = Repository(
            id: 1,
            name: "RepoExemplo",
            htmlUrl: "",
            stargazersCount: 34532,
            owner: Owner(login: "usuarioTeste",
                         avatarUrl: ""),
            description: "Sem descrição",
            forksCount: 12434,
            forksUrl: ""
        )
        viewModel = PullRequestsViewModel(repository: dummyRepo, service: mockService)
    }

    func testFetchPullRequests_success() {
        let mockPRs = [
            PullRequest(id: 1, title: "PR 1", htmlUrl: "", user: User(login: "User1"), body: "Body 1", createdAt: Date()),
            PullRequest(id: 2, title: "PR 2", htmlUrl: "", user: User(login: "User2"), body: "Body 2", createdAt: Date())
        ]
        mockService.mockPullRequests = mockPRs
        
        let expectation = self.expectation(description: "Deve carregar os PRs com sucesso")

        viewModel.pullRequests
            .skip(1)
            .subscribe(onNext: { prs in
                XCTAssertEqual(prs.count, mockPRs.count)
                XCTAssertEqual(prs[0].title, "PR 1")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchPullRequests()
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testFetchPullRequests_failure() {

        mockService.shouldFailPRs = true
        
        let expectation = self.expectation(description: "Deve retornar erro")
        
        viewModel.error
            .drive(onNext: { message in
                XCTAssert(message.contains("Erro ao carregar PRs"))
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchPullRequests()
        
        waitForExpectations(timeout: 2.0)
    }
}
