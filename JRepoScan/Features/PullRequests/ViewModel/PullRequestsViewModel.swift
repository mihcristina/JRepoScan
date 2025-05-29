//
//  PullRequestsViewModel.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import UIKit

class PullRequestsViewModel {
    private let repository: Repository
    private(set) var pullRequests: [PullRequest] = []

    var onUpdate: (() -> Void)?

    init(repository: Repository) {
        self.repository = repository
    }

    func fetchPullRequests() {
        let urlString = "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/pulls"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    self.pullRequests = try decoder.decode([PullRequest].self, from: data)
                    DispatchQueue.main.async {
                        self.onUpdate?()
                    }
                } catch {
                    print("Erro decodificando PRs:", error)
                }
            }
        }.resume()
    }
}
