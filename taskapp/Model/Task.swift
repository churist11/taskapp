//
//  Task.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/09.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {

	// Relationship to one Category
	@objc dynamic var category: Category?
	
	// Title
	@objc dynamic var title: String = ""

	// Contents
	@objc dynamic var contents: String = ""

	// Date
	@objc dynamic var date: Date = Date()

	// ID for management
	@objc dynamic var id: Int = 0
	
	// Set id as primary key
	override class func primaryKey() -> String? {
		return "id"
	}
}
