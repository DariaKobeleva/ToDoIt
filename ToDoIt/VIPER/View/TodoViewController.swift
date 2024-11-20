//
//  TodoViewController.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

final class TodoViewController: UIViewController, TodoViewProtocol {
    
    var presenter: TodoPresenter?
    
    private var todos: [Todo] = []
    
    private let tableView = UITableView()
    
    private let searchBar = UISearchBar()
    
    private let footerView = UIView()
    
    private let tasksCountLabel = UILabel()
    
    private let editButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TodoViewController: View did load.")
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        setupFooterView()
        setupTapGestureToDismissKeyboard()
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchTextField.textColor = .gray
        searchBar.backgroundColor = .systemBackground
        searchBar.searchTextField.leftView?.tintColor = .darkGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        )
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ToDoCustomCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupFooterView() {
        footerView.backgroundColor = .black
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)
        
        tasksCountLabel.textColor = .lightGray
        tasksCountLabel.font = UIFont.systemFont(ofSize: 16)
        tasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(tasksCountLabel)
        
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .yellow
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            tasksCountLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            tasksCountLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }
    
    @objc private func editButtonTapped() {
        print("TodoViewController: Edit button tapped.")
        let detailViewController = TodoDetailViewController()
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Методы TodoViewProtocol
    func displayTodos(_ todos: [Todo]) {
        print("TodoViewController: Displaying \(todos.count) todos.")
        self.todos = todos
        tasksCountLabel.text = "\(todos.count) Задач"
        tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        print("TodoViewController: Displaying error - \(error.localizedDescription).")
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource и UITableViewDelegate

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? ToDoCustomCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.checkboxTapped = { [weak self] in
            guard let self = self else { return }
            let updatedTodo = Todo(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                currentDate: todo.currentDate,
                isCompleted: !todo.isCompleted
            )
            self.presenter?.updateExistingTodo(updatedTodo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let overlay = TodoOverlayView(frame: view.bounds)
        overlay.configure(with: todo)
        
        overlay.onEditTapped = { [weak self] in
            guard let self = self else { return }
            let detailViewController = TodoDetailViewController()
            detailViewController.todo = todo
            detailViewController.delegate = self
            self.navigationController?.pushViewController(detailViewController, animated: true)
            overlay.removeFromSuperview()
        }
        
        overlay.onDeleteTapped = { [weak self] in
            guard let self = self else { return }
            self.presenter?.deleteExistingTodo(todo)
            overlay.removeFromSuperview()
        }
        
        overlay.onShareTapped = { [weak self] in
            guard let self = self else { return }
            let activityController = UIActivityViewController(activityItems: [todo.title, todo.description], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        
        view.addSubview(overlay)
    }
}

// MARK: - UISearchBarDelegate

extension TodoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.viewDidLoad()
        } else {
            presenter?.searchTodos(with: searchText)
        }
    }
}

// MARK: - TodoDetailDelegate

extension TodoViewController: TodoDetailDelegate {
    func didSaveTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            presenter?.updateExistingTodo(todo)
        } else {
            todos.append(todo)
            tableView.reloadData()
            presenter?.addNewTodo(todo)
        }
    }
}

extension TodoViewController {
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndClearSearch))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboardAndClearSearch() {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.text = ""
            presenter?.viewDidLoad()
        }
        view.endEditing(true)
    }
}
