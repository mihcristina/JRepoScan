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

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoMedium.withSize(14)
        label.textAlignment = .center
        label.textColor = AppColor.primary.color
        return label
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoMedium.withSize(14)
        label.textColor = AppColor.primary.color
        label.numberOfLines = 0
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoRegular.withSize(12)
        label.numberOfLines = 3
        label.textColor = AppColor.secondary.color
        return label
    }()

    private var forkStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()

    private var forkImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "fork")
        return image
    }()

    private var forkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoRegular.withSize(12)
        label.textColor = AppColor.fork.color
        return label
    }()

    private var starStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()

    private var starImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "Vector")
        return image
    }()

    private var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoRegular.withSize(12)
        label.textColor = AppColor.star.color
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configCell(image: String, titleLabel: String, description: String, nameOwner: String, forkLabel: String, starsNumber: String) {
        self.imageProfile.loadImage(from: image)
        self.titleLabel.text = titleLabel
        self.descriptionLabel.text = description
        self.nameLabel.text = nameOwner
        self.forkLabel.text = forkLabel
        self.starLabel.text = starsNumber

        setupAccessibility(textDescription: description)
    }
}

extension RepoViewTableViewCell: ViewCodable {
    func buildHierarchy() {
        addSubview(imageProfile)
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(forkStackView)
        forkStackView.addArrangedSubview(forkImage)
        forkStackView.addArrangedSubview(forkLabel)
        addSubview(starStackView)
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(starLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageProfile.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            imageProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            imageProfile.heightAnchor.constraint(equalToConstant: 88),
            imageProfile.widthAnchor.constraint(equalToConstant: 88),

            nameLabel.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            nameLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            titleLabel.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageProfile.topAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 18),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            forkStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            forkStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            forkStackView.bottomAnchor.constraint(equalTo: imageProfile.bottomAnchor),

            starStackView.topAnchor.constraint(equalTo: forkStackView.topAnchor),
            starStackView.leadingAnchor.constraint(equalTo: forkStackView.trailingAnchor, constant: 10),
            starStackView.bottomAnchor.constraint(equalTo: forkStackView.bottomAnchor),

            starImage.heightAnchor.constraint(equalToConstant: 10),
            forkImage.heightAnchor.constraint(equalToConstant: 10),
        ])
    }

    private func setupAccessibility(textDescription: String) {
        isAccessibilityElement = true
        accessibilityTraits = [.button]

        let titulo = "Título: \(titleLabel.text ?? "")"
        let responsavel = "Responsável: \(nameLabel.text ?? "")"
        let descricao: String

        if self.isPortuguese(text: textDescription) {
            descricao = "Descrição: \(descriptionLabel.text ?? "")"
        } else {
            descricao = "Descrição em outro idioma"
        }

        let forks = "Número de fórquis: \(forkLabel.text ?? "0")"
        let estrelas = "Número de estrelas: \(starLabel.text ?? "0")"

        accessibilityLabel = [titulo, responsavel, descricao, forks, estrelas].joined(separator: ". ")
        accessibilityHint = "Toque duas vezes para abrir os Pull Recuéstis do repositório."
    }

    func configView() {
        backgroundColor = .clear
    }
}
