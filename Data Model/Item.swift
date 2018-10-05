//
//  Item.swift
//  ToDoeyRealm
//
//  Created by Chandrika Bajoria on 04/10/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
      @objc dynamic var title : String = ""
      @objc dynamic var done : Bool = false
      let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
