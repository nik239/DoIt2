//
//  ListsControllerDataSource.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 14/12/2023.
//

import UIKit
import CoreData

final class ListsControllerDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    var lists = fetchedResultsController.fetchedObjects!
    let list = lists[sourceIndexPath.row]
    lists.remove(at: sourceIndexPath.row)
    lists.insert(list, at: destinationIndexPath.row)
    for (index, list) in lists.enumerated() {
      list.customSort = Int16(exactly:index)!
    }
    PersistenceController.shared.saveContext()
  }
}
