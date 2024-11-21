//
//  ToDoOverlayView.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

final class ToDoOverlayView: UIView {
    
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
    private var actionItems: [ActionItem] = []
    
    
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
        
        buttonContainer.backgroundColor = UIColor(hex: "#EDEDEDCC")
        buttonContainer.layer.cornerRadius = 12
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonContainer)
        
        configureButton(
            editButton,
            title: "Редактировать",
            titleColor: UIColor(hex: "#040404") ?? .black,
            imageName: "pencilBorder",
            action: #selector(editTapped)
        )
        addSeparator(below: editButton)
        
        configureButton(
            shareButton,
            title: "Поделиться",
            titleColor: UIColor(hex: "#040404") ?? .black,
            imageName: "share",
            action: #selector(shareTapped)
        )
        addSeparator(below: shareButton)
        
        configureButton(
            deleteButton,
            title: "Удалить",
            titleColor: UIColor(hex: "#D70015") ?? .systemRed,
            imageName: "trash",
            action: #selector(deleteTapped)
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.baseForegroundColor = titleColor
        
        if let imageName = imageName {
            configuration.image = UIImage(named: imageName)?
                .withRenderingMode(.alwaysOriginal)
                .resizeImage(to: CGSize(width: 16, height: 16))
        }
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16)
        
        button.configuration = configuration
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(button)
    }
    
    private func addSeparator(below button: UIButton) {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "#4D555E80")?.withAlphaComponent(0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: button.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 0),
            separator.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: 0),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
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
            
            // Контейнер кнопок с гибкой шириной
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor), // Центрируем по горизонтали
            buttonContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16), // Минимальный отступ от краёв
            buttonContainer.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16), // Максимальный отступ от краёв
            buttonContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 254), // Максимальная ширина
            buttonContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            buttonContainer.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 16),
            buttonContainer.heightAnchor.constraint(equalToConstant: 180),
            
            // Кнопка "Редактировать"
            editButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка "Поделиться"
            shareButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16),
            shareButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка "Удалить"
            deleteButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: -16)
        ])
    }
    
    
    func configure(with todo: ToDo) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        dateLabel.text = DateFormatter.localizedString(from: todo.currentDate, dateStyle: .short, timeStyle: .none)
    }
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoActionCell.reuseIdentifier, for: indexPath) as? ToDoActionCell else {
            return UITableViewCell()
        }
        
        let item = actionItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = actionItems[indexPath.row]
        item.action()
        tableView.deselectRow(at: indexPath, animated: true)
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

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
