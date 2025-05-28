//
//  HomeViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeViewController: UIViewController {
    var homeView: HomeView?
    let viewModel = HomeViewModel()

    override func loadView() {
        homeView = HomeView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView?.tableViewDelegation(delegate: self, datasource: self)
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let homeView = self.homeView else { return }
                homeView.tableView.reloadData()
            }
        }
        viewModel.loadRepositories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = viewModel.repositories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoViewTableViewCell.identifier, for: indexPath) as? RepoViewTableViewCell
        cell?.configCell(image: repo.owner.avatarUrl, titleLabel: repo.name)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
