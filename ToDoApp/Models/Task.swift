//
//  Task.swift
//  ToDoApp
//
//  Created by Josip Hranić on 24.12.2020..
//

import Foundation

struct Task: Codable {

    public let id: UUID?
    public let title: String
    public let subtitle: String?
    public let createdDate: Date
    public let isDone: Bool
}
