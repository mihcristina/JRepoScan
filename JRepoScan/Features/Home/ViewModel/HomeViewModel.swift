//
//  HomeViewModel.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeViewModel {
    private var service = GitHubAPIService()
    private(set) var repositories: [Repository] = []
    private var currentPage = 1
    private var isLoading = false

    var onUpdate: (() -> Void)?

    func fetchRepositoriesIfNeeded(currentRow: Int) {
        if currentRow >= repositories.count - 5 && !isLoading {
            loadRepositories()
        }
    }

    func loadRepositories() {
        guard !isLoading else { return }
        isLoading = true

        service.fetchRepositories(page: currentPage) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let newRepos):
                    self.repositories += newRepos
                    self.currentPage += 1
                    self.onUpdate?()
                case .failure(let error):
                    print("Failed to load repos: \(error)")
                }
                self.isLoading = false
            }
        }
    }

    func repository(at index: Int) -> Repository {
        return repositories[index]
    }

    var count: Int {
        return repositories.count
    }
}
