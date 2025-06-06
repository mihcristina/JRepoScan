//
//  CustomView.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

protocol CustomViewDelegate: AnyObject {
    func backButtonTapped()
}

class CustomView: UIView {
    internal var navName: String?
    internal var isHome: Bool = true
    internal weak var delegate: CustomViewDelegate?

    private lazy var customNav: CustomNavigationBar = {
        let nav = CustomNavigationBar(title: navName ?? "JRepoScan", type: isHome ? .menu(action: {
            print("algo legal aqui")
        }) : .back(action: {
            self.delegate?.backButtonTapped()
        }), rightButtonAction: {
            print("ainda vai ter algo legal aqui")
        })
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()

    internal lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RepoViewTableViewCell.self, forCellReuseIdentifier: RepoViewTableViewCell.identifier)
        table.register(PRViewTableViewCell.self, forCellReuseIdentifier: PRViewTableViewCell.identifier)
        return table
    }()

    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(navName: String, isHome: Bool) {
        self.navName = navName
        self.isHome = isHome
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableViewDelegation(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

}

extension CustomView: ViewCodable {
    func buildHierarchy() {
        addSubview(customNav)
        addSubview(tableView)
        addSubview(activityIndicator)
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
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configView() {
        backgroundColor = AppColor.accent.color
        tableView.backgroundColor = AppColor.background.color

        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        accessibilityElements = [customNav, tableView]
    }

}
