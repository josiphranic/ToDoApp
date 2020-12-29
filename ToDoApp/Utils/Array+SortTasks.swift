//
//  Array+SortTasks.swift
//  ToDoApp
//
//  Created by Josip Hranić on 25.12.2020..
//

import Foundation

extension Array where Element == Task {

    func sort() -> [Task] {
        sorted(by: { first, second in
            if !first.isDone && second.isDone {
                return true
            } else if first.isDone == second.isDone {
                return first.createdDate.timeIntervalSince1970 < second.createdDate.timeIntervalSince1970
            } else {
                return false
            }
        })
    }
}
