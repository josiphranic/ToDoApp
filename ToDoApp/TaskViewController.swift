//
//  TaskViewController.swift
//  ToDoApp
//
//  Created by Josip Hranić on 26.12.2020..
//

import UIKit

class TaskViewController: UIViewController {

    private let taskView = TaskView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        addSubviews()
        layout()
    }
}

// MARK: Public methods
extension TaskViewController {

    func update(task: Task) {
        taskView.update(task: task)
    }

    func update(onDoneClicked: @escaping ((_ task: Task) -> ()),
                onDeleteClicked: @escaping ((_ task: Task) -> ())) {
        taskView.update(onDoneClicked: onDoneClicked,
                        onDeleteClicked: onDeleteClicked)
    }
}

// MARK: Private methods
private extension TaskViewController {

    func addSubviews() {
        view.addSubview(taskView)
    }

    func layout() {
        taskView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}
