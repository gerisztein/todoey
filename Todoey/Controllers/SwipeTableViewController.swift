//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Lucas Gerisztein on 25.02.20.
//  Copyright © 2020 Lucas Gerisztein. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
  }
  
  // MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    
        cell.delegate = self
        
        return cell

  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      self.deleteItem(at: indexPath)
    }
    
    let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
      self.editItem(at: indexPath)
    }
    
    deleteAction.image = UIImage(systemName: "trash")
    editAction.image = UIImage(systemName: "pencil")
    
    return [deleteAction, editAction]
    
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    
    return options
    
  }
  
  func deleteItem(at indexPath: IndexPath) {
  }
  
  func editItem(at indexPath: IndexPath) {
  }
}
