//
//  CreateTaskView.swift
//  ToDoApp
//
//  Created by Josip Hranić on 26.12.2020..
//

import UIKit

class CreateTaskView: UIView {

    private let titleTextField = UITextField()
    private let subtitleTextField = UITextField()
    private let createButton = UIButton()
    private var onCreatedTask: ((_ task: Task) -> ())?

    init() {
        super.init(frame: .zero)
        addSubviews()
        setupTextFields()
        setupButtons()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods
extension CreateTaskView {

    func update(onCreatedTask: @escaping ((_ task: Task) -> ())) {
        self.onCreatedTask = onCreatedTask
    }
}

// MARK: Private methods
private extension CreateTaskView {

    func addSubviews() {
        addSubview(titleTextField)
        addSubview(subtitleTextField)
        addSubview(createButton)
    }

    func setupButtons() {
        createButton.setTitle("Create",
                              for: .normal)
        createButton.setTitleColor(.black,
                                   for: .normal)
        createButton.backgroundColor = .systemGray
        createButton.layer.cornerRadius = 10
        createButton.addTarget(self,
                               action: #selector(onCreateClick),
                               for: .touchUpInside)
    }

    func setupTextFields() {
        titleTextField.font = UIFont.boldSystemFont(ofSize: 14)
        titleTextField.placeholder = "Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.setContentHuggingPriority(.defaultHigh,
                                                 for: .vertical)
        subtitleTextField.font = UIFont.systemFont(ofSize: 12)
        subtitleTextField.placeholder = "Subtitle"
        subtitleTextField.borderStyle = .roundedRect
        subtitleTextField.setContentHuggingPriority(.defaultLow,
                                                    for: .vertical)
    }

    func layout() {
        titleTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
        }

        subtitleTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(createButton.snp.top).offset(-20)
        }

        createButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }

    func animateMissingTitle() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        titleTextField.layer.removeAllAnimations()
        titleTextField.layer.add(flash, forKey: nil)
    }

    @objc func onCreateClick() {
        guard let title = titleTextField.text,
              !title.isEmpty else {
            animateMissingTitle()
            return
        }
        let date = Date()
        let subtitle = subtitleTextField.text
        let task = Task(id: nil,
                        title: title,
                        subtitle: subtitle,
                        createdDate: date,
                        isDone: false)
        onCreatedTask?(task)
    }
}
