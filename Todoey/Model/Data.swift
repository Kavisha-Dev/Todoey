//
//  Data.swift
//  Todoey
//
//  Created by Kavisha on 16/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Data : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0;

    
}
