//
//  Item.swift
//  Todoey
//
//  Created by Lucas Gerisztein on 25.02.20.
//  Copyright © 2020 Lucas Gerisztein. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var dateCreated: Date?
  
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
