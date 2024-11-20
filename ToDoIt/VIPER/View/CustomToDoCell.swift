//
//  CustomTaskCell.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 19.11.2024.
//

import UIKit

final class CustomToDoCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let checkboxButton = UIButton(type: .custom)
    private let separatorView = UIView() // Сепаратор между ячейками
    
    var checkboxTapped: (() -> Void)? // Замыкание для обработки нажатия на чекбокс
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        // Настройка кнопки чекбокса
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.tintColor = .yellow
        checkboxButton.addTarget(self, action: #selector(checkboxTappedAction), for: .touchUpInside)
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkboxButton)
        
        // Настройка заголовка
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Настройка описания
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // Настройка даты
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        // Настройка сепаратора
        separatorView.backgroundColor = .darkGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1) // Высота сепаратора
        ])
    }
    
    @objc private func checkboxTappedAction() {
        checkboxTapped?()
    }
    
    func configure(with task: Task) {
        // Устанавливаем текст
        descriptionLabel.text = task.description
        dateLabel.text = DateFormatter.localizedString(from: task.createdAt, dateStyle: .short, timeStyle: .none)
        
        // Проверяем состояние чекбокса и обновляем стили
        if task.isCompleted {
            checkboxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkboxButton.tintColor = .yellow // Жёлтая обводка и галочка
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue] // Зачёркнутый текст
            )
        } else {
            checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkboxButton.tintColor = .gray // Серая обводка
            titleLabel.attributedText = nil
            titleLabel.text = task.title
        }
    }
}

