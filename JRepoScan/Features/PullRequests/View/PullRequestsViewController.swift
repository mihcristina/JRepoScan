//
//  PullRequestsViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import RxCocoa
import RxSwift
import UIKit

class PullRequestsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PullRequestsViewModel
    private var prView: CustomView?
    private var navName: String?
    
    override func loadView() {
        prView = CustomView(navName: navName ?? "", isHome: false)
        view = prView
    }

    init(repository: Repository) {
        navName = repository.name
        viewModel = PullRequestsViewModel(repository: repository)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não implementado")
    }

    override func viewDidLoad() {
        prView?.tableViewDelegation(delegate: self)
        super.viewDidLoad()
        prView?.delegate = self
        bindViewModel()
        viewModel.fetchPullRequests()
    }

    func bindViewModel() {
        guard let prView = prView else { return }
        viewModel.pullRequests
            .bind(to: prView.tableView.rx.items(cellIdentifier: PRViewTableViewCell.identifier, cellType: PRViewTableViewCell.self)) { (row, pr, cell) in
                cell.configCell(
                    titleLabel: pr.title,
                    descriptionLabel: pr.body ?? "Sem Descrição",
                    profileName: pr.user.login,
                    date: pr.createdAt)
            }
            .disposed(by: disposeBag)
        
        prView.tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [weak self] repo in
                let vc = PullRequestsViewController(repository: repo)
                self?.navigationController?.pushViewController(vc, animated: true)
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

extension PullRequestsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension PullRequestsViewController: CustomViewDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
