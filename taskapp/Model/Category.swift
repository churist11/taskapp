//
//  Category.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/13.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{

	// Relationships to many Task
	internal let tasks = LinkingObjects(fromType: Task.self, property: "category")

	// Name
	@objc dynamic var name: String = ""

	// ID for management
	@objc dynamic var id: Int = 0

	// Set id as primary key
	override class func primaryKey() -> String? {
		return "id"
	}
}
