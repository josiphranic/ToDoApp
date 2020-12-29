//
//  TaskDataHandler.swift
//  ToDoApp
//
//  Created by Josip Hranić on 24.12.2020..
//

import Foundation
import Alamofire

protocol TaskDataHandlerDelegate: AnyObject {

    func loadedTasks(tasks: [Task])

    func createdTask(task: Task)

    func deletedTask(task: Task)

    func updatedTask(task: Task)
}

class TaskDataHandler {

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let baseURlString = "http://localhost:8080/todos"
    weak var delegate: TaskDataHandlerDelegate?

    // TODO api client, loading loop view
    init() {
        setupEncoder()
        setupDecoder()
    }
}

// MARK: Public methods
extension TaskDataHandler {

    func loadTasks() {
        AF.request(baseURlString)
            .validate()
            .responseDecodable(of: Array<Task>.self,
                               decoder: decoder) { [weak self] response in
                let tasks = response.value ?? []
                self?.delegate?.loadedTasks(tasks: tasks)
            }
    }

    func createTask(task: Task) {
        guard let url = URL(string: baseURlString),
              let jsonData = try? encoder.encode(task) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        AF.request(request)
            .validate()
            .responseDecodable(of: Task.self,
                               decoder: decoder) { [weak self] response in
                guard let task = response.value else {
                    return
                }
                self?.delegate?.createdTask(task: task)
        }
    }

    func deleteTask(task: Task) {
        guard let taskId = task.id,
              let urlString = URL(string: "\(baseURlString)/\(taskId)") else {
            return
        }
        AF.request(urlString,
                   method: .delete)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success( _):
                    self?.delegate?.deletedTask(task: task)
                case .failure( _):
                    break
                }
            }
    }

    func updateTask(taskId: UUID,
                    task: Task) {
        guard let taskId = task.id,
              let url = URL(string: "\(baseURlString)/\(taskId)"),
              let jsonData = try? encoder.encode(task) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        AF.request(request)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success( _):
                    self?.delegate?.updatedTask(task: task)
                case .failure( _):
                    break
                }
            }
    }
}

// MARK: Private methods
private extension TaskDataHandler {

    func setupEncoder() {
        encoder.dateEncodingStrategy = .iso8601
    }

    func setupDecoder() {
        decoder.dateDecodingStrategy = .iso8601
    }
}
