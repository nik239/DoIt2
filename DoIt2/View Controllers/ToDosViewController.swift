//
//  ViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit

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
  private var model: ToDosViewModel
  weak var delegate: ToDosViewControllerDelegate?
  
  init(style: UITableView.Style, currentList: ToDoItemList) {
    model = ToDosViewModel(currentList: currentList)
    super.init(style: style)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
  
  private func setupUI() {
    navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    self.navigationItem.title = model.currentList.title
  }
  
  private lazy var addButton: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    return btn
  }()
  
  @objc func addButtonTapped() {
    delegate!.toDosViewControllerDidPressAdd(currentList: model.currentList)
  }
}

//MARK: Life Cycle
extension ToDosViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    model.tableView = tableView
    setupUI()
    setupTableView()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    UIView.performWithoutAnimation {
      model.fetchData()
    }
  }
}

//MARK: TableView
extension ToDosViewController {
  private func setupTableView() {
    tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.todo.rawValue)")
    tableView.register(CompletedToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.finished.rawValue)")
    model.dataSource = model.configureDataSource()
    tableView.delegate = self
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
      self!.model.markAsComplete(indexPath: indexPath, completionHandler: completionHandler)
    }
    completeAction.backgroundColor = UIColor.systemGreen
    let configuration = UISwipeActionsConfiguration(actions: [completeAction])
    return configuration
  }
}

