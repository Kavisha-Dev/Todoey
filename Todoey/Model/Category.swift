//
//  Category.swift
//  Todoey
//
//  Created by Kavisha on 16/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = "";
    var items = List<Item>();
    @objc dynamic var colour : String = "";
    
}
