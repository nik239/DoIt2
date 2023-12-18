//
//  SortPreferences.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 15/12/2023.
//

import Foundation

enum ToDosSorts: String, CaseIterable {
  case dateNewest
  case dateOldest
//  case priorityHighest
//  case priorityLowest
  case custom
}

enum ListsSorts: String, CaseIterable {
  case dateNewest = "Date(Newest)"
  case dateOldest = "Date(Oldest)"
  case custom = "Custom"
}

struct ListsSortPreference {
  var current: ListsSorts {
    get {
      ListsSorts(rawValue: UserDefaults.standard.string(forKey: "listsSortPreference") ?? ListsSorts.dateNewest.rawValue)!
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: "listsSortPreference")
    }
  }
}

struct ToDosSortPreference {
  var current: ToDosSorts {
    get {
      ToDosSorts(rawValue: UserDefaults.standard.string(forKey: "ToDosSortPreference") ?? ToDosSorts.dateNewest.rawValue)!
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: "ToDosSortPreference")
    }
  }
}
