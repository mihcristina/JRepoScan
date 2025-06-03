//
//  HomeViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {
    var homeView: CustomView = CustomView(navName: "JRepoScan", isHome: true)
    let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = homeView
    }

    init() {
        self.viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.tableViewDelegation(delegate: self)
        viewModel.isLoading
            .drive(homeView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        bindViewModel()
        viewModel.loadRepositories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func bindViewModel() {
        viewModel.repositories
            .bind(to: homeView.tableView.rx.items(cellIdentifier: RepoViewTableViewCell.identifier, cellType: RepoViewTableViewCell.self)) { (row, repo, cell) in
                cell.configCell(
                    image: repo.owner.avatarUrl,
                    titleLabel: repo.name,
                    description: repo.description,
                    nameOwner: repo.owner.login,
                    forkLabel: String(repo.forksCount),
                    starsNumber: String(repo.stargazersCount)
                )
            }
            .disposed(by: disposeBag)
        
        homeView.tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [weak self] repo in
                let vc = PullRequestsViewController(repository: repo)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        homeView.tableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                let offsetY = contentOffset.y
                let contentHeight = self.homeView.tableView.contentSize.height
                let frameHeight = self.homeView.tableView.frame.size.height
                
                if offsetY > contentHeight - frameHeight * 2 {
                    self.viewModel.fetchRepositoriesIfNeeded(currentRow: self.viewModel.count - 1)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] message in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
