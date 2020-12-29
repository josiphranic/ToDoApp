//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by Josip Hranić on 26.12.2020..
//

import UIKit

class CreateTaskViewController: UIViewController {

    private let createTaskView = CreateTaskView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        title = "New task"
        addSubviews()
        layout()
    }
}

// MARK: Public methods
extension CreateTaskViewController {

    func update(onCreatedTask: @escaping ((_ task: Task) -> ())) {
        createTaskView.update(onCreatedTask: onCreatedTask)
    }
}

// MARK: Private methods
private extension CreateTaskViewController {

    func addSubviews() {
        view.addSubview(createTaskView)
    }

    func layout() {
        createTaskView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}
