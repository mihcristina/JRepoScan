//
//  PullRequestsViewModel.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import RxCocoa
import RxSwift
import UIKit

class PullRequestsViewModel {
    private let repository: Repository
    private let service: GitHubAPIServiceProtocol
    private let disposeBag = DisposeBag()

    let pullRequests = BehaviorRelay<[PullRequest]>(value: [])
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _error = PublishRelay<String>()

    var isLoading: Driver<Bool> {
        _isLoading.asDriver()
    }

    var error: Driver<String> {
        _error.asDriver(onErrorJustReturn: "Erro desconhecido")
    }

    private var currentPage = 1
    private var isFetching = false
    private var hasMore = true

    init(repository: Repository, service: GitHubAPIService) {
        self.repository = repository
        self.service = service
    }

    func fetchPullRequests() {
        guard !isFetching, hasMore else { return }
        isFetching = true
        _isLoading.accept(true)

        service.fetchPullRequestsRx(owner: repository.owner.login, repo: repository.name, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] prs in
                    guard let self = self else { return }
                    let updated = self.pullRequests.value + prs
                    self.pullRequests.accept(updated)
                    self.currentPage += 1
                    self.hasMore = !prs.isEmpty
                    self._isLoading.accept(false)
                    self.isFetching = false
                },
                onError: { [weak self] error in
                    self?._error.accept("Erro ao carregar PRs: \(error.localizedDescription)")
                    self?._isLoading.accept(false)
                    self?.isFetching = false
                }
            )
            .disposed(by: disposeBag)
    }
}
