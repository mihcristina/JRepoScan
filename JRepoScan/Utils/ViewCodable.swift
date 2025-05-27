//
//  ViewCodable.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import Foundation

protocol ViewCodable {
    func buildHierarchy()
    func setupConstraints()
    func configView()
    func setupView()
}

extension ViewCodable {
    func setupView() {
        buildHierarchy()
        setupConstraints()
        configView()
    }
}
