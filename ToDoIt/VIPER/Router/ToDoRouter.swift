//
//  ToDoRouter.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

protocol TodoRouterProtocol {
    static func createModule() -> UIViewController
}

final class ToDoRouter: TodoRouterProtocol {

    static func createModule() -> UIViewController {
        print("TodoRouter: Creating VIPER module.")
        
        let viewController = ToDoViewController()
        let presenter = ToDoPresenter()
        let interactor = ToDoInteractor()
        let router = ToDoRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter             
        
        return viewController
    }
}

