//
//  ViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit
import CoreData

enum Section: Int, CaseIterable {
    case active
    case finished
}

final class ToDosViewController: UITableViewController {
    var dataSource: TaskListDataSource!
    var currentList: ToDoItemList
    
    init(style: UITableView.Style, currentList: ToDoItemList) {
        self.currentList = currentList
        super.init(style: style)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) isn't implemented")
    }
    
    //MARK:- View Setup
    lazy var addButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return btn
    }()
    
    @objc func addButtonTapped() {
        self.navigationController?.pushViewController(NewItemViewController(currentList: currentList), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [editButtonItem, addButton]
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Section.active.rawValue)")
        tableView.register(CompletedToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Section.finished.rawValue)")
        configureDataSource()
        dataSource.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.update()
    }
    
    func configureDataSource() {
        dataSource = TaskListDataSource(currentList: currentList, tableView: tableView) {
            tableView, indexPath, task -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"\(ToDoItemCell.self)\(indexPath.section)", for: indexPath) as? ToDoItemCell
                else { fatalError("Could not create TaskCell") }
            cell.lblDescription.text = task.taskDescription
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Done!") { //why weak self here?
            [weak self] (action, view, completionHandler) in
            if indexPath.section == Section.finished.rawValue {
                completionHandler(false)
                return
            }
            self?.destroyAndRemake(atIndex: indexPath.row, withDataSource: self?.dataSource)
            completionHandler(true)
        }
        
        completeAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [completeAction])
        return configuration
    }
    
    //used as a workaround for strikethrough not applying to newely finished ToDoItems
    //(problem with diffableDataSource cell reuse), no great solutions
    //should probably switch to old data source
    func destroyAndRemake(atIndex index: Int, withDataSource dataSource: TaskListDataSource?){
        let request = ToDoItem.activeToDosFetchRequest(list: currentList)
        var taskDescription = ""
        do {
            let results = try PersistenceController.shared.container.viewContext.fetch(request)
            let objectToComplete = results[index] as ToDoItem
            taskDescription = objectToComplete.taskDescription
            PersistenceController.shared.container.viewContext.delete(objectToComplete)
        } catch {
            print("Failed to fetch ToDos!")
        }
        dataSource?.update()
        ToDoItem.createWith(taskDescription: taskDescription, isComplete: true, list: currentList)
        PersistenceController.safeContextSave()
        dataSource?.update()
    }
}

