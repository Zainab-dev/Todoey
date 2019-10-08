//
//  Category.swift
//  Todoey
//
//  Created by zainab on 07/10/2019.
//  Copyright © 2019 zainab. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name:String = ""
   let items = List<Item>()
}
