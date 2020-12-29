//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Josip Hranić on 25.12.2020..
//

import UIKit
import SnapKit

class TaskCell: UITableViewCell {

    private let view = TaskCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods
extension TaskCell {

    func update(task: Task) {
        view.update(task: task)
    }

    func update(onDoneClicked: @escaping ((_ task: Task) -> ()),
                onDeleteClicked: @escaping ((_ task: Task) -> ())) {
        view.update(onDoneClicked: onDoneClicked,
                    onDeleteClicked: onDeleteClicked)
    }
}

// MARK: Private methods
private extension TaskCell {

    func addSubviews() {
        contentView.addSubview(view)
    }

    func layout() {
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
