//
//  CustomNavigation.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

enum NavigationBarType {
    case menu(action: () -> Void)
    case back(action: () -> Void)
    case none
}

class CustomNavigationBar: UIView {

    private var type: NavigationBarType = .none
    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.accent.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.accent.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Notification"), for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()

    init(title: String, type: NavigationBarType, rightButtonAction: (() -> Void)? = nil) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        configure(title: title, type: type, rightButtonAction: rightButtonAction)
        configAccessibility(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, type: NavigationBarType, rightButtonAction: (() -> Void)?) {
        titleLabel.text = title
        self.rightAction = rightButtonAction
        rightButton.isHidden = (rightButtonAction == nil)

        switch type {
        case .menu(let action):
            leftButton.setImage(UIImage(named: "sandwiche"), for: .normal)
            leftAction = action
        case .back(let action):
            leftButton.setImage(UIImage(named: "back"), for: .normal)
            leftAction = action
        case .none:
            leftButton.isHidden = true
            leftAction = nil
        }
    }

    @objc private func leftButtonTapped() {
        leftAction?()
    }

    @objc private func rightButtonTapped() {
        rightAction?()
    }

    private func configAccessibility(title: String?) {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .header
        titleLabel.accessibilityLabel = "Título da tela: \(title ?? "")"

        rightButton.accessibilityLabel = "Notificações"
        leftButton.accessibilityTraits = .button

        switch type {
        case .menu:
            leftButton.accessibilityLabel = "Menu Sanduíche"
        case .back:
            leftButton.accessibilityLabel = "Voltar"
        case .none:
            leftButton.accessibilityLabel = nil
        }
        rightButton.accessibilityTraits = .button
    }
}

extension CustomNavigationBar: ViewCodable {
    func buildHierarchy() {
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 30),
            leftButton.heightAnchor.constraint(equalToConstant: 30),

            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 30),
            rightButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configView() {
        backgroundColor = AppColor.background.color
    }
}
