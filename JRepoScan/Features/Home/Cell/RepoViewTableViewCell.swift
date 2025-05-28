//
//  RepoViewTableViewCell.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class RepoViewTableViewCell: UITableViewCell {

    static var identifier: String = "RepoViewTableViewCell"

    private var imageProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 14
        image.image = UIImage(named: "git")
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RepoViewTableViewCell: ViewCodable {
    func buildHierarchy() {
        addSubview(imageProfile)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            imageProfile.heightAnchor.constraint(equalToConstant: 88),
            imageProfile.widthAnchor.constraint(equalToConstant: 88),
        ])
    }
    
    func configView() {
        backgroundColor = .clear
    }
}
