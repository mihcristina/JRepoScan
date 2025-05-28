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

    private let titleLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?

    init(title: String, type: NavigationBarType, rightButtonAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        setupViews()
        configure(title: title, type: type, rightButtonAction: rightButtonAction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = AppColor.background.color

        leftButton.tintColor = AppColor.accent.color
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        addSubview(leftButton)

        rightButton.tintColor = AppColor.accent.color
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setImage(UIImage(named: "Notification"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        addSubview(rightButton)

        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

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
}
