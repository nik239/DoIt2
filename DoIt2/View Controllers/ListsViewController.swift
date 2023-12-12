//
//  ListsViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import CoreData

final class ListsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    var dataSource: UITableViewDiffableDataSource<Section, ToDoItemList>! //obesrvable around
    //this
    lazy var addButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return btn
    }()
    @objc func addButtonTapped() {
        //present sheet view
        let newListViewController = NewListViewController()
        newListViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        newListViewController.transitioningDelegate = self
        present(newListViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [editButtonItem, addButton]
        tableView.register(ListCell.self, forCellReuseIdentifier: "\(ListCell.self)")
        configureDataSource()
        updateDataSource()
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) {
            tableView, indexPath, toDoList -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"\(ListCell.self)", for: indexPath) as? ListCell
                else { fatalError("Could not create ListCell") }
            cell.lblDescription.text = toDoList.title
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toDoList = dataSource.itemIdentifier(for: indexPath) else {
            print("Could not find the underlieing ToDoList!")
            return
        }
        self.navigationController?.pushViewController(ToDosViewController(style: .plain, currentList: toDoList), animated: true)
    }
    
    func updateDataSource() {
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, ToDoItemList>()
        newSnapshot.appendSections(Section.allCases)
        let request = ToDoItemList.fetchRequest()
        let results = try! PersistenceController.shared.container.viewContext.fetch(request)
        newSnapshot.appendItems(results, toSection: .active)
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }
}
