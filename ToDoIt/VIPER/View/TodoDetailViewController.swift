//
//  TodoDetailViewController.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

protocol TodoDetailDelegate: AnyObject {
    func didSaveTodo(_ todo: Todo)
}

final class TodoDetailViewController: UIViewController {
    
    var todo: Todo?
    
    weak var delegate: TodoDetailDelegate?
    
    private let titleTextField = UITextField()
    
    private let descriptionTextView = UITextView()
    
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let todo = todo {
            titleTextField.text = todo.title
            descriptionTextView.text = todo.description
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        titleTextField.placeholder = "Название"
        titleTextField.backgroundColor = .darkGray
        titleTextField.textColor = .white
        titleTextField.font = .boldSystemFont(ofSize: 18)
        titleTextField.layer.cornerRadius = 8
        titleTextField.layer.masksToBounds = true
        titleTextField.setLeftPaddingPoints(8)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.backgroundColor = .darkGray
        descriptionTextView.textColor = .lightGray
        descriptionTextView.font = .systemFont(ofSize: 14)
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.yellow, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.layer.cornerRadius = 8
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.yellow.cgColor
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),
            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Заголовок не может быть пустым.")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        
        let updatedTodo = Todo(
            id: todo?.id ?? UUID(),
            title: title,
            description: description,
            currentDate: todo?.currentDate ?? Date(),
            isCompleted: todo?.isCompleted ?? false
        )
        
        delegate?.didSaveTodo(updatedTodo)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}

