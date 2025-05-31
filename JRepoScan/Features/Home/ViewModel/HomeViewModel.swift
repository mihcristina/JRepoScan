//
//  HomeViewModel.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewModel {
    private var hasMore = true
    private let service: GitHubAPIServiceProtocol
    private let disposeBag = DisposeBag()

    let repositories = BehaviorRelay<[Repository]>(value: [])
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

    init(service: GitHubAPIServiceProtocol) {
        self.service = service
    }

    func fetchRepositoriesIfNeeded(currentRow: Int) {
        if currentRow >= repositories.value.count - 5 && !isFetching {
            loadRepositories()
        }
    }

    func loadRepositories() {
        guard !isFetching, hasMore else { return }
        isFetching = true
        _isLoading.accept(true)

        service.fetchRepositoriesRx(page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] newRepos in
                    guard let self = self else { return }
                    let updated = self.repositories.value + newRepos
                    self.repositories.accept(updated)
                    self.currentPage += 1
                    self.hasMore = !newRepos.isEmpty
                    self._isLoading.accept(false)
                    self.isFetching = false
                },
                onError: { [weak self] error in
                    self?._error.accept("Erro ao carregar repositórios: \(error.localizedDescription)")
                    self?._isLoading.accept(false)
                    self?.isFetching = false
                }
            )
            .disposed(by: disposeBag)
    }

    func repository(at index: Int) -> Repository {
        repositories.value[index]
    }

    var count: Int {
        repositories.value.count
    }
}
