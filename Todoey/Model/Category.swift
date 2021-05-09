//
//  Category.swift
//  Todoey
//
//  Created by Gurpreet Singh on 2021-04-30.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// So by subclassing this object class. We're able to save our data using realm. And we can specify for our classes, what properties it should have. And for the category, it has a name property, it's going to be the name of the category. And this is a dynamic variable, so we can monitor for changes in this property, while the app is running  and we've also got this relationship and it specifies that each category, can have a number of items, and that is a list of item objects
class Category: Object {
    @objc dynamic var name: String =  ""
    @objc dynamic var hexColor: String =  ""
    let items = List<Item>()
}
