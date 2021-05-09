//
//  Item.swift
//  Todoey
//
//  Created by Gurpreet Singh on 2021-04-30.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// Items also subclassing the realm object, and that allows them to be saved using realm as well. It has three properties, a title, whether if it was done or not. And also, now it has a date created, property. And finally, we specify the inverse relationship that links each item back to a parent category. And we specify the type of the destination of the link. And we also specify the property name of the inverse relationship. And that relates to this property.
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
