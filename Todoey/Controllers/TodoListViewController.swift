//
//  ViewController.swift
//  Todoey
//
//  Created by Lucas Gerisztein on 25.02.20.
//  Copyright © 2020 Lucas Gerisztein. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
  
  let realm = try! Realm()
  var todoItems: Results<Item>?
  
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    title = selectedCategory?.name
    
  }
  
  // MARK: - Actions
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      if let selectedCategory = self.selectedCategory {
        
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            selectedCategory.items.append(newItem)
          }
        } catch {
          print("Error saving item. \(error)")
        }
        
        self.tableView.reloadData()
      }
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "e.g. Buy bananas"
      textField = alertTextField
    }
    
    present(alert, animated: true, completion: nil)
    
  }
  
  // MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return todoItems?.count ?? 1
    
  }
  
  //  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
  //      cell.delegate = self
  //      return cell
  //  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    cell.textLabel?.text = "No items added yet."
    
    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      cell.accessoryType = item.done ? .checkmark : .none
    }
    
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try self.realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error updating item. \(error)")
      }
      
      tableView.reloadData()
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
  }
  
  // MARK: - Data Manipulation Methods
  
  func loadItems() {
    
    todoItems = selectedCategory?.items
      .sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
    
  }
  
  override func deleteItem(at indexPath: IndexPath) {
    if let item = todoItems?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(item)
        }
      } catch {
        print("Error deleting item. \(error)")
      }
    }
  }
  
  override func editItem(at indexPath: IndexPath) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Save", style: .default) {
      (action) in
      
      if let message = textField.text {
        do {
          try self.realm.write {
            self.todoItems?[indexPath.row].title = message
          }
        } catch {
          print("Error editing item. \(error)")
        }
        
        self.tableView.reloadData()
      }
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField { (alertTextField) in
      alertTextField.text = self.todoItems?[indexPath.row].title
      textField = alertTextField
    }
    
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?
      .filter("title CONTAINS[cd] %@", searchBar.text!)
      .sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchBar.text?.count == 0 {
      loadItems()
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
    
  }
}
