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
        return image
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .black)
        label.textColor = .white
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configCell(image: String, titleLabel: String) {
        self.imageProfile.loadImage(from: image)
        self.titleLabel.text = titleLabel
    }
}

extension RepoViewTableViewCell: ViewCodable {
    func buildHierarchy() {
        addSubview(imageProfile)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            imageProfile.heightAnchor.constraint(equalToConstant: 88),
            imageProfile.widthAnchor.constraint(equalToConstant: 88),

            titleLabel.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageProfile.topAnchor),
        ])
    }
    
    func configView() {
        backgroundColor = .clear
    }
}
