//
//  Category.swift
//  Todoey
//
//  Created by Lucas Gerisztein on 25.02.20.
//  Copyright © 2020 Lucas Gerisztein. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  
  let items = List<Item>()
}
