//
//  HomeView.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeView: UIView {
    private lazy var customNav: CustomNavigationBar = {
        let nav = CustomNavigationBar(title: "JRepoScan", type: .menu(action: {
            print("Vem um menu bem legal aqui")
        })) {
            print("notificaçãozinha hein")
        }
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RepoViewTableViewCell.self, forCellReuseIdentifier: RepoViewTableViewCell.identifier)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableViewDelegation(delegate: UITableViewDelegate, datasource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = datasource
    }

}

extension HomeView: ViewCodable {
    func buildHierarchy() {
        addSubview(customNav)
        addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            customNav.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNav.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNav.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNav.heightAnchor.constraint(equalToConstant: 56),
            
            tableView.topAnchor.constraint(equalTo: customNav.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configView() {
        backgroundColor = AppColor.accent.color
        tableView.backgroundColor = AppColor.background.color
    }

}
