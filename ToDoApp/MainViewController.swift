//
//  ViewController.swift
//  ToDoApp
//
//  Created by Josip Hranić on 24.12.2020..
//

import UIKit

class MainViewController: UITableViewController {

    private let taskCellIdentifier = String(describing: TaskCell.self)
    private let dataHandler = TaskDataHandler()
    private var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupNavigationBar()
        setupRefreshControl()
        setupTableView()
        setupDataHandler()
        dataHandler.loadTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
}

// MARK: Private methods
private extension MainViewController {

    func setupNavigationBar() {
        title = "ToDos"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(onAddTaskClicked))
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self,
                                  action: #selector(onRefresh),
                                  for: .valueChanged)
    }

    func setupTableView() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: taskCellIdentifier)
    }

    func setupDataHandler() {
        dataHandler.delegate = self
    }

    @objc func onAddTaskClicked() {
        let createTaskViewController = CreateTaskViewController()
        navigationController?.pushViewController(createTaskViewController,
                                                 animated: true)
        createTaskViewController.update(onCreatedTask: onCreateTask(task:))
    }

    func onTaskClicked(task: Task) {
        let taskViewController = TaskViewController()
        navigationController?.pushViewController(taskViewController,
                                                 animated: true)
        taskViewController.update(task: task)
        taskViewController.update(onDoneClicked: onDoneChangedForTask(task:),
                                  onDeleteClicked: onDeleteTask(task:))
    }

    @objc func onRefresh() {
        dataHandler.loadTasks()
    }

    func reloadData() {
        guard !tableView.hasUncommittedUpdates else {
            return
        }
        tableView.reloadData()
    }
}

// MARK: Private methods - lifecycle
private extension MainViewController {
    // TODO remove lifecycle from VC
    func onDoneChangedForTask(task: Task) {
        let tasksToUpdated = tasks.filter { $0.id == task.id }
        let newTasks = tasksToUpdated.map { Task(id: $0.id,
                                                 title: $0.title,
                                                 subtitle: $0.subtitle,
                                                 createdDate: $0.createdDate,
                                                 isDone: !$0.isDone) }
        newTasks.forEach {
            if let taskId = $0.id {
                dataHandler.updateTask(taskId: taskId,
                                       task: $0)
            }
        }
    }

    func onDeleteTask(task: Task) {
        removeFromStack(typeOf: TaskViewController.self)
        dataHandler.deleteTask(task: task)
    }

    func onCreateTask(task: Task) {
        removeFromStack(typeOf: CreateTaskViewController.self)
        dataHandler.createTask(task: task)
    }
}

// MARK: UITableViewDelegate
extension MainViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = tasks.item(at: indexPath.row) else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        onTaskClicked(task: task)
    }
}

// MARK: UITableViewDataSource
extension MainViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = tasks.item(at: indexPath.row),
              let cell = tableView
                .dequeueReusableCell(withIdentifier: taskCellIdentifier) as? TaskCell else {
            return TaskCell()
        }
        cell.update(task: task)
        cell.update(onDoneClicked: onDoneChangedForTask(task:),
                    onDeleteClicked: onDeleteTask(task:))

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
}

// MARK: TaskDataHandlerDelegate
extension MainViewController: TaskDataHandlerDelegate {

    func updatedTask(task: Task) {
        dataHandler.loadTasks()
    }

    func createdTask(task: Task) {
        dataHandler.loadTasks()
    }

    func deletedTask(task: Task) {
        dataHandler.loadTasks()
    }

    func loadedTasks(tasks: [Task]) {
        self.tasks = tasks.sort()
        reloadData()
        if let isRefreshing = refreshControl?.isRefreshing,
           isRefreshing {
            refreshControl?.endRefreshing()
        }
    }
}

