//
//  Category.swift
//  ToDoeyRealm
//
//  Created by Chandrika Bajoria on 04/10/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import Foundation
import RealmSwift

class  Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
