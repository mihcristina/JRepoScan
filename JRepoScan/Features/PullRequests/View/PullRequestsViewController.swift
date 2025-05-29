//
//  PullRequestsViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import UIKit

class PullRequestsViewController: UIViewController {
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
        prView?.tableViewDelegation(delegate: self, datasource: self)
        prView?.delegate = self
        super.viewDidLoad()
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let homeView = self.prView else { return }
                homeView.tableView.reloadData()
            }
        }
        viewModel.fetchPullRequests()
    }
}

extension PullRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pullRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pr = viewModel.pullRequests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PRViewTableViewCell.identifier, for: indexPath) as? PRViewTableViewCell
        cell?.configCell(titleLabel: pr.title, descriptionLabel: pr.body ?? "Sem descrição", profileName: pr.user.login, date: pr.createdAt)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension PullRequestsViewController: CustomViewDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
