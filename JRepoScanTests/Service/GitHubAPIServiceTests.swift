//
//  GitHubAPIServiceTests.swift
//  JRepoScanTests
//
//  Created by Michelli Cristina de Paulo Lima on 31/05/25.
//


import XCTest
import RxSwift
import RxBlocking
@testable import JRepoScan

final class GitHubAPIServiceTests: XCTestCase {
    var service: GitHubAPIService!

    override func setUp() {
        super.setUp()
        service = GitHubAPIService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testFetchRepositoriesRx() {
        do {
            let repos = try service.fetchRepositoriesRx(page: 1)
                .toBlocking(timeout: 5)
                .first()
            
            XCTAssertNotNil(repos)
            XCTAssertGreaterThan(repos?.count ?? 0, 0, "Deveria retornar pelo menos um repositório")
        } catch {
            XCTFail("Erro inesperado: \(error)")
        }
    }

    func testFetchPullRequestsRx() {
        do {
            let prs = try service.fetchPullRequestsRx(owner: "apple", repo: "swift", page: 1)
                .toBlocking(timeout: 5)
                .first()
            
            XCTAssertNotNil(prs)
            XCTAssertGreaterThan(prs?.count ?? 0, 0, "Deveria retornar pelo menos um Pull Request")
        } catch {
            XCTFail("Erro inesperado: \(error)")
        }
    }

}
