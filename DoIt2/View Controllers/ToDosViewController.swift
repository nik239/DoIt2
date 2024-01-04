//
//  ViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit
import CoreData

enum Sections: String, CaseIterable {
  case todo = " Current:"
  case finished = " Finished:"
  
  static func sectionFor(_ isComplete: Bool) -> Sections {
    return isComplete ? .finished : .todo
  }
}

protocol ToDosViewControllerDelegate: AnyObject {
  func toDosViewControllerDidPressAdd(currentList: ToDoItemList)
}

final class ToDosViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  private var dataSource: ToDosViewDataSource?
  var currentList: ToDoItemList
  weak var delegate: ToDosViewControllerDelegate?
  
  init(style: UITableView.Style, currentList: ToDoItemList) {
    self.currentList = currentList
    super.init(style: style)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
  
  private func setupUI() {
    navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    self.navigationItem.title = currentList.title
  }
  
  private lazy var addButton: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    return btn
  }()
  
  @objc func addButtonTapped() {
    delegate!.toDosViewControllerDidPressAdd(currentList: currentList)
  }
}

//MARK: Life Cycle
extension ToDosViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupTableView()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    UIView.performWithoutAnimation {
      do {
        try dataSource!.fetchedResultsController.performFetch()
      } catch let error as NSError {
        print("Fetching error: \(error), \(error.userInfo)")
      }
    }
  }
}

//MARK: TableView
extension ToDosViewController {
  private func setupTableView() {
    tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.todo.rawValue)")
    tableView.register(CompletedToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.finished.rawValue)")
    dataSource = configureDataSource()
    tableView.delegate = self
  }
  func configureDataSource() -> ToDosViewDataSource {
    ToDosViewDataSource(currentList: currentList, tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      if managedObjectID.isTemporaryID {
        print("temporary ID!")
      }
      if let toDo = try?
          PersistenceController.shared.context.existingObject(with: managedObjectID) as? ToDoItem {
        let id = "\(ToDoItemCell.self)" + Sections.sectionFor(toDo.isComplete).rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ToDoItemCell
        cell.lblDescription.text = toDo.taskDescription
        if !toDo.isComplete {
          cell.imgvPriority.tintColor = Priorities(rawValue: toDo.priority)!.color
        }
        return cell
      }
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    let lblSection = UILabel()
    lblSection.text = Sections.sectionFor(section == 1).rawValue
    lblSection.font = UIFont.boldSystemFont(ofSize: 20)
    return lblSection
  }
  
  override func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int)
    -> CGFloat {
    20
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let completeAction = UIContextualAction(style: .normal, title: "Done!") {
      [weak self] (action, view, completionHandler) in
      let toDo = self!.dataSource!.fetchedResultsController.object(at: indexPath)
      if toDo.isComplete {
        completionHandler(false)
        return
      }
      toDo.isComplete = true
      PersistenceController.shared.saveContext()
      completionHandler(true)
    }
    
    completeAction.backgroundColor = UIColor.systemGreen
    let configuration = UISwipeActionsConfiguration(actions: [completeAction])
    return configuration
  }
}

