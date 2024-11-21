//
//  ActionItem.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 21.11.2024.
//

import UIKit

struct ActionItem {
    let title: String
    let iconName: String
    let titleColor: UIColor
    let action: () -> Void
}
