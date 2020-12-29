//
//  UIViewController+Remove.swift
//  ToDoApp
//
//  Created by Josip Hranić on 29.12.2020..
//

import UIKit

extension UIViewController {

    func removeFromStack(typeOf: AnyClass) {
        navigationController?
            .viewControllers
            .enumerated()
            .filter { type(of: $0.1) == typeOf }
            .reversed()
            .map { $0.0 }
            .forEach {
                navigationController?
                    .viewControllers
                    .remove(at: $0)
            }
    }
}
