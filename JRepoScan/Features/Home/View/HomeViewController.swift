//
//  HomeViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeViewController: UIViewController {
    var homeView: CustomView?
    let viewModel = HomeViewModel()

    override func loadView() {
        homeView = CustomView(navName: "JRepoScan", isHome: true)
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
        cell?.configCell(image: repo.owner.avatarUrl, titleLabel: repo.name, description: repo.description, nameOwner: repo.owner.login, forkLabel: String(repo.forksCount), starsNumber: String(repo.stargazersCount))
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = viewModel.repositories[indexPath.row]
        let vc = PullRequestsViewController(repository: repo)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * 2 {
            viewModel.fetchRepositoriesIfNeeded(currentRow: viewModel.count - 1)
        }
    }
}
