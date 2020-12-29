//
//  TaskCellView.swift
//  ToDoApp
//
//  Created by Josip Hranić on 25.12.2020..
//

import UIKit

class TaskCellView: UIView {

    private let doneImageView = UIImageView()
    private let deleteImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var onDoneClicked: ((_ task: Task) -> ())?
    private var onDeleteClicked: ((_ task: Task) -> ())?
    private var task: Task?

    init() {
        super.init(frame: .zero)
        addSubviews()
        setupLabels()
        setupImageViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods
extension TaskCellView {

    func update(task: Task) {
        self.task = task
        titleLabel.text = task.title
        subtitleLabel.text = task.subtitle
        let doneImage = task.isDone ? UIImage(systemName: "largecircle.fill.circle") : UIImage(systemName: "circle")
        doneImageView.image = doneImage
    }

    func update(onDoneClicked: @escaping ((_ task: Task) -> ()),
                onDeleteClicked: @escaping ((_ task: Task) -> ())) {
        self.onDoneClicked = onDoneClicked
        self.onDeleteClicked = onDeleteClicked
    }
}

// MARK: Private methods
private extension TaskCellView {

    func addSubviews() {
        addSubview(doneImageView)
        addSubview(deleteImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    func setupLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
    }

    func setupImageViews() {
        deleteImageView.image = UIImage(systemName: "trash")
        doneImageView.contentMode = .scaleAspectFit
        deleteImageView.contentMode = .scaleAspectFit
        deleteImageView.isUserInteractionEnabled = true
        doneImageView.isUserInteractionEnabled = true
        doneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(onDoneImageViewTap)))
        deleteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(onDeleteImageViewTap)))
    }

    func layout() {
        doneImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.height.equalTo(20)
        }

        deleteImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(doneImageView.snp.trailing).offset(8)
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalTo(deleteImageView.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    @objc func onDoneImageViewTap() {
        guard let task = task else {
            return
        }
        onDoneClicked?(task)
    }

    @objc func onDeleteImageViewTap() {
        guard let task = task else {
            return
        }
        onDeleteClicked?(task)
    }
}
