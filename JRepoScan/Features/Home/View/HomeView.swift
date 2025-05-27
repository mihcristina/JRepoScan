//
//  HomeView.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeView: UIView {

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeView: ViewCodable {
    func buildHierarchy() {
        
    }

    func setupConstraints() {
        
    }

    func configView() {
        backgroundColor = UIColor(hex: "#1E1E2F")
    }

}
