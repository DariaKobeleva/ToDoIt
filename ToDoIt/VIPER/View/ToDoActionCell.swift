//
//  ActionCell.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 21.11.2024.
//

import UIKit

final class ToDoActionCell: UITableViewCell {
    static let reuseIdentifier = "ActionCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: ActionItem) {
        titleLabel.text = item.title
        titleLabel.textColor = item.titleColor
        iconImageView.image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = item.titleColor
    }
}
