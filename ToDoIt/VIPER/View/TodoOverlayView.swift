//
//  TodoOverlayView.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

final class TodoOverlayView: UIView {
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let textContainer = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let buttonContainer = UIView()
    private let editButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGesture)
        
        textContainer.backgroundColor = UIColor(hex: "#272729")
        textContainer.layer.cornerRadius = 12
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textContainer)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(descriptionLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(dateLabel)
        
        buttonContainer.backgroundColor = .white
        buttonContainer.layer.cornerRadius = 12
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonContainer)
        
        configureButton(
            editButton,
            title: "Редактировать",
            titleColor: .systemBlue,
            imageName: "pencil",
            action: #selector(editTapped)
        )
        configureButton(
            deleteButton,
            title: "Удалить",
            titleColor: .systemRed,
            imageName: "trash",
            action: #selector(deleteTapped)
        )
        configureButton(
            shareButton,
            title: "Поделиться",
            titleColor: .systemGray,
            imageName: "square.and.arrow.up",
            action: #selector(shareTapped)
        )
        
        setupConstraints()
    }
    
    private func configureButton(
        _ button: UIButton,
        title: String,
        titleColor: UIColor,
        imageName: String?,
        action: Selector
    ) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.baseForegroundColor = titleColor
        configuration.image = UIImage(systemName: imageName ?? "")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        button.configuration = configuration
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(button)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: -16),
            
            buttonContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            buttonContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            buttonContainer.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 16),
            buttonContainer.heightAnchor.constraint(equalToConstant: 180),
            
            editButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            
            shareButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16),
            shareButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            
            deleteButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with todo: Todo) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        dateLabel.text = DateFormatter.localizedString(from: todo.currentDate, dateStyle: .short, timeStyle: .none)
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
    @objc private func editTapped() {
        onEditTapped?()
    }
    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
    
    @objc private func shareTapped() {
        onShareTapped?()
    }
}
