//
//  Category.swift
//  Todoey
//
//  Created by Gurpreet Singh on 2021-04-30.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String =  ""
    let items = List<Item>()
}
