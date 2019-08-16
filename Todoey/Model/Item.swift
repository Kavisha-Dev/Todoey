//
//  Item.swift
//  Todoey
//
//  Created by Kavisha on 16/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title: String  = "";
    
    @objc dynamic var done:Bool  = false;
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items");
}
