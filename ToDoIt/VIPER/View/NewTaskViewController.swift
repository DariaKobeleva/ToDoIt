//
//  NewTaskViewController.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 18.11.2024.
//

import UIKit

final class NewTaskViewController: UIViewController {
    weak var delegate: NewTaskViewControllerDelegate?
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Save Task",
            color: .systemMint,
            action: UIAction { [unowned self] _ in
                save()
            }
        )
        
        return filledButtonFactory.createButton()
    }()
    
    private lazy var cancelButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Cancel Task",
            color: .milkRed,
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
        
        return filledButtonFactory.createButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubview(taskTextField, saveButton, cancelButton)
        setConstraints()
    }
    
    private func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let task = ToDoTask(context: appDelegate.persistentContainer.viewContext)
        task.title = taskTextField.text
        appDelegate.saveContext()
        delegate?.reloadData()
        dismiss(animated: true)
    }
}

