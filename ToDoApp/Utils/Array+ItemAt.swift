//
//  Array+ItemAt.swift
//  ToDoApp
//
//  Created by Josip Hranić on 25.12.2020..
//

import Foundation

extension Array {

    func item(at index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }
}
