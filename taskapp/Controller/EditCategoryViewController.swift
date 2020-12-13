//
//  EditCategoryViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/13.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift

class EditCategoryViewController: UIViewController {


	// MARK: - IBOutlet


	@IBOutlet weak var nameTextField: UITextField!


	// MARK: - Stored Property


	// Get reference to realm DB
	private var realm = try! Realm()

	// Get reference to given task editing now
	internal var task: Task!
	

	// MARK: - LifeCycle


    override func viewDidLoad() {
        super.viewDidLoad()

//		print(self.task!)

    }

	
	// MARK: - IBAction


	@IBAction func saveTapped(_ sender: UIBarButtonItem) {

		// Create blank category
		let newCategory = Category()

		// Set name to new category
		newCategory.name = self.nameTextField.text!

		try! self.realm.write {

			// Add new category into Realm
			self.realm.add(newCategory)

			// Modify category property of the task
			self.task.category?.name = self.nameTextField.text!
		}
	}


}// Endline
