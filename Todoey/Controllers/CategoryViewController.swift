//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lucas Gerisztein on 25.02.20.
//  Copyright © 2020 Lucas Gerisztein. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
  
  let realm = try! Realm()
  var categoryList: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  // MARK: - Actions
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      if let message = textField.text {
        let newCategory = Category()
        newCategory.name = message
        
        self.save(category: newCategory)
        self.tableView.reloadData()
      }
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "e.g. Grocery"
      textField = alertTextField
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - TableView DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryList?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No categories added yet."
    
    return cell
  }
  
  // MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destination.selectedCategory = categoryList?[indexPath.row]
    }
  }
  
  // MARK: - Data Manipulation Methods
  
  func loadCategories() {
    categoryList = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  func save(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context. \(error)")
    }
    
  }
  
  override func deleteItem(at indexPath: IndexPath) {
    if let category = categoryList?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(category)
        }
      } catch {
        print("Error deleting category. \(error)")
      }
    }
  }
  
  override func editItem(at indexPath: IndexPath) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Edit category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Save", style: .default) { (action) in
      
      if let message = textField.text {
        do {
          try self.realm.write {
            self.categoryList?[indexPath.row].name = message
          }
        } catch {
          print("Error editing category. \(error)")
        }
        
        self.tableView.reloadData()
      }
    }
    
    alert.addAction(action)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "e.g. Grocery"
      alertTextField.text = self.categoryList?[indexPath.row].name
      textField = alertTextField
    }
    
    self.present(alert, animated: true, completion: nil)
  }
}
