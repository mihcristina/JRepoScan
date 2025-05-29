//
//  PRViewTableViewCell.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import UIKit

class PRViewTableViewCell: UITableViewCell {

    static var identifier: String = "PRViewTableViewCell"

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoMedium.withSize(16)
        label.textColor = AppColor.primary.color
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoRegular.withSize(12)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = AppColor.secondary.color
        return label
    }()

    private var dateImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "date")
        return image
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoMedium.withSize(14)
        label.textColor = AppColor.primary.color
        return label
    }()

    private var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "profile")
        return image
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFont.robotoMedium.withSize(14)
        label.textColor = AppColor.primary.color
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

    public func configCell(titleLabel: String, descriptionLabel: String, profileName: String, date: Date) {
        self.titleLabel.text = titleLabel
        self.descriptionLabel.text = descriptionLabel
        self.nameLabel.text = profileName
        let formatter = DateFormatter()
        formatter.dateFormat = "dd 'de' MMMM 'de' yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        self.dateLabel.text = formatter.string(from: date)


        setupAccessibility(textDescription: descriptionLabel)
    }
}

extension PRViewTableViewCell: ViewCodable {
    func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateImage)
        addSubview(dateLabel)
        addSubview(profileImage)
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),

            dateImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            dateImage.heightAnchor.constraint(equalToConstant: 20),

            dateLabel.topAnchor.constraint(equalTo: dateImage.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateImage.trailingAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: dateImage.bottomAnchor),

            profileImage.topAnchor.constraint(equalTo: dateImage.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: dateImage.bottomAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 20),
    
            nameLabel.topAnchor.constraint(equalTo: dateImage.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            nameLabel.bottomAnchor.constraint(equalTo: dateImage.bottomAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: dateImage.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        ])
    }

    private func setupAccessibility(textDescription: String) {
        isAccessibilityElement = false

        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Título: \(titleLabel.text ?? "")"
        titleLabel.accessibilityTraits = .header

        dateLabel.isAccessibilityElement = true
        dateLabel.accessibilityLabel = "Data: \(dateLabel.text ?? "")"

        nameLabel.isAccessibilityElement = true
        nameLabel.accessibilityLabel = "Responsável: \(nameLabel.text ?? "")"

        descriptionLabel.isAccessibilityElement = true
        if self.isPortuguese(text: textDescription) {
            descriptionLabel.accessibilityLabel = "Descrição: \(descriptionLabel.text ?? "")"
        } else {
            descriptionLabel.accessibilityLabel = "Descrição em outro idioma"
        }

        self.accessibilityElements = [
            titleLabel,
            dateLabel,
            nameLabel,
            descriptionLabel
        ]
    }
    
    func configView() {
        backgroundColor = .clear
    }
}
