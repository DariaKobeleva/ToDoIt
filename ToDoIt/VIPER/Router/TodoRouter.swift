//
//  TodoRouter.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

protocol TodoRouterProtocol {
    static func createModule() -> UIViewController
}

final class TodoRouter: TodoRouterProtocol {

    static func createModule() -> UIViewController {
        print("TodoRouter: Creating VIPER module.")
        
        let viewController = TodoViewController()
        let presenter = TodoPresenter()
        let interactor = TodoInteractor()
        let router = TodoRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter             
        
        return viewController
    }
}

