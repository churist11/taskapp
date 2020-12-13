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

	@IBOutlet weak var alertLabel: UILabel!

	@IBOutlet weak var nameTextField: UITextField!


	// MARK: - Stored Property


	// Get reference to realm DB
	private var realm = try! Realm()

	// Get reference to given task editing now
	internal var task: Task!
	

	// MARK: - LifeCycle


    override func viewDidLoad() {
        super.viewDidLoad()

		// Assign self as delegate
		self.nameTextField.delegate = self

		// Hide label
		self.alertLabel.isHidden = true

    }

	
	// MARK: - IBAction


	@IBAction func saveTapped(_ sender: UIBarButtonItem) {

		// Check text field has text
		if self.nameTextField.text
			== "" {

			// Show label
			self.alertLabel.isHidden = false

				return
		}

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

		// Back to InputVC
		self.navigationController?.popViewController(animated: true)
	}


}// Endline


// MARK: - UITextFieldDelegate Method


extension EditCategoryViewController: UITextFieldDelegate {

	// Activate return button
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		// Close keyboard
		textField.endEditing(true)
		return true
	}

	// Detect start editing
	func textFieldDidBeginEditing(_ textField: UITextField) {

		// Re-hide label
		self.alertLabel.isHidden = true
	}

}
