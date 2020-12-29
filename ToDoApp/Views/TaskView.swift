//
//  TaskView.swift
//  ToDoApp
//
//  Created by Josip Hranić on 26.12.2020..
//

import UIKit

class TaskView: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let creationDateLabel = UILabel()
    private let isDoneImageView = UIImageView()
    private let deleteImageView = UIImageView()
    private let dateFormatter = DateFormatter()
    private var onDoneClicked: ((_ task: Task) -> ())?
    private var onDeleteClicked: ((_ task: Task) -> ())?
    private var task: Task?

    init() {
        super.init(frame: .zero)
        addSUbviews()
        setupLabels()
        setupImageViews()
        setupDateFormetter()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods
extension TaskView {

    func update(task: Task) {
        self.task = task
        updateLabels()
        updateImageViews()
    }

    func update(onDoneClicked: @escaping ((_ task: Task) -> ()),
                onDeleteClicked: @escaping ((_ task: Task) -> ())) {
        self.onDoneClicked = onDoneClicked
        self.onDeleteClicked = onDeleteClicked
    }
}

// MARK: Private methods
private extension TaskView {

    func addSUbviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(creationDateLabel)
        addSubview(isDoneImageView)
        addSubview(deleteImageView)
    }

    func setupLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        creationDateLabel.font = .systemFont(ofSize: 10)
    }

    func setupImageViews() {
        deleteImageView.image = UIImage(systemName: "trash")
        isDoneImageView.contentMode = .scaleAspectFit
        deleteImageView.contentMode = .scaleAspectFit
        deleteImageView.isUserInteractionEnabled = true
        isDoneImageView.isUserInteractionEnabled = true
        isDoneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(onDoneImageViewTap)))
        deleteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(onDeleteImageViewTap)))
    }

    func setupDateFormetter() {
        dateFormatter.timeStyle = .medium
    }

    func layout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(isDoneImageView.snp.trailing).offset(8)
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalTo(deleteImageView.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
        }

        creationDateLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(titleLabel)
            $0.leading.greaterThanOrEqualTo(titleLabel)
            $0.bottom.lessThanOrEqualToSuperview()
        }

        isDoneImageView.snp.makeConstraints {
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
    }

    func updateLabels() {
        guard let task = task else {
            return
        }
        titleLabel.text = task.title
        subtitleLabel.text = task.subtitle
        creationDateLabel.text = dateFormatter
            .string(from: task.createdDate)
    }

    func updateImageViews() {
        guard let task = task else {
            return
        }
        let doneImage = task.isDone ?
            UIImage(systemName: "largecircle.fill.circle") :
            UIImage(systemName: "circle")
        isDoneImageView.image = doneImage
    }

    @objc func onDoneImageViewTap() {
        guard let task = task else {
            return
        }
        // TODO load task from api
        self.task = Task(id: task.id,
                         title: task.title,
                         subtitle: task.subtitle,
                         createdDate: task.createdDate,
                         isDone: !task.isDone)
        updateImageViews()
        onDoneClicked?(task)
    }

    @objc func onDeleteImageViewTap() {
        guard let task = task else {
            return
        }
        deleteImageView.isHidden = true
        onDeleteClicked?(task)
    }
}
