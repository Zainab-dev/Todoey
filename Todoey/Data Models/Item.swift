//
//  Item.swift
//  Todoey
//
//  Created by zainab on 07/10/2019.
//  Copyright © 2019 zainab. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title:String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
   var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
   
}
