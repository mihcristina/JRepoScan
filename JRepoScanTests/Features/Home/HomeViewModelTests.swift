//
//  HomeViewModelTests.swift
//  JRepoScanTests
//
//  Created by Michelli Cristina de Paulo Lima on 31/05/25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import JRepoScan

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
        var mockService: MockGitHubAPIService!
        var disposeBag: DisposeBag!

        override func setUp() {
            super.setUp()
            mockService = MockGitHubAPIService()
            disposeBag = DisposeBag()
            viewModel = HomeViewModel(service: mockService)
        }

        func testLoadRepositories_success() {
            let expectedRepos = [
                Repository(id: 1, name: "Repo1", htmlUrl: "", stargazersCount: 13434, owner:  Owner(login: "user1", avatarUrl: ""), description: "", forksCount: 13542, forksUrl: ""),
                Repository(id: 2, name: "Repo2", htmlUrl: "", stargazersCount: 13434, owner:  Owner(login: "user2", avatarUrl: ""), description: "", forksCount: 14242, forksUrl: "")
            ]
            mockService.mockRepositories = expectedRepos
            
            let expectation = self.expectation(description: "Repos carregados com sucesso")

            viewModel.repositories
                .skip(1)
                .subscribe(onNext: { repos in

                    XCTAssertEqual(repos.count, expectedRepos.count)
                    XCTAssertEqual(repos[0].name, "Repo1")
                    expectation.fulfill()
                })
                .disposed(by: disposeBag)

            viewModel.loadRepositories()

            waitForExpectations(timeout: 2.0)
        }

        func testLoadRepositories_failure() {
            mockService.shouldFailRepos = true
            let expectation = self.expectation(description: "Deve emitir erro")

            viewModel.error
                .drive(onNext: { error in
                    XCTAssertTrue(error.contains("Erro ao carregar repositórios"))
                    expectation.fulfill()
                })
                .disposed(by: disposeBag)

            viewModel.loadRepositories()

            waitForExpectations(timeout: 2.0)
        }

        func testFetchRepositoriesIfNeeded_triggersLoadNearEnd() {

            let existingRepos = (0..<10).map {
                Repository(id: $0, name: "Repo\($0)", htmlUrl: "", stargazersCount: 13434, owner:  Owner(login: "user\($0)", avatarUrl: ""), description: "", forksCount: 13542, forksUrl: "")
            }
            mockService.mockRepositories = [Repository(id: 11, name: "NewRepo", htmlUrl: "", stargazersCount: 13453535334, owner:  Owner(login: "NewUser", avatarUrl: ""), description: "desc", forksCount: 14343542, forksUrl: "")]
            viewModel.repositories.accept(existingRepos)

            let expectation = self.expectation(description: "loadRepositories deve ser chamado ao atingir fim da lista")

            viewModel.repositories
                .skip(1)
                .subscribe(onNext: { repos in
                    XCTAssertEqual(repos.count, 11)
                    XCTAssertEqual(repos.last?.name, "NewRepo")
                    expectation.fulfill()
                })
                .disposed(by: disposeBag)

            viewModel.fetchRepositoriesIfNeeded(currentRow: 9)

            waitForExpectations(timeout: 2.0)
        }
}
