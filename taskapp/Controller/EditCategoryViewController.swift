//
//  EditCategoryViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/13.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift

final class EditCategoryViewController: UIViewController {


	// MARK: - IBOutlet


	@IBOutlet weak var alertLabel: UILabel!
	@IBOutlet weak var nameTextField: UITextField!


	// MARK: - Stored Property


	// Get reference to realm DB
	private var realm = try! Realm()

	// Task that editing now
	internal var task: Task!

	
	// MARK: - LifeCycle


	override func viewDidLoad() {
		super.viewDidLoad()

		// Assign self as delegate
		self.nameTextField.delegate = self

		// Hide label
		self.alertLabel.isHidden = true

//		// Hide back button
//		self.navigationItem.hidesBackButton = true

		// Disable button
		self.navigationItem.rightBarButtonItem?.isEnabled = false

	}

	
	// MARK: - IBAction

	@IBAction func saveTapped(_ sender: UIButton) {

		// Check text field has text
		if self.nameTextField.text
			== "" {

			// Show label
			self.alertLabel.isHidden = false

			return
		}

		// <Confugure new category>
		// 1. Create blank category
		let newCategory = Category()

		// 2. Set name to the category from text field
		newCategory.name = self.nameTextField.text!

		// 3. Get all objects in realm
		let allCategory = self.realm.objects(Category.self)

		// 4. Create new id for the category
		if allCategory.count != 0 {


			let newID = allCategory.max(ofProperty: "id")!
				+ 1

			// Set new id into the category
			newCategory.id = newID
		}

		// Deal with DB
		try! self.realm.write {

			// Add new category into Realm
			self.realm.add(newCategory)
		}

		// Show label
		self.alertLabel.isHidden = false
		self.alertLabel.text = "save complete!!"
		self.alertLabel.textColor = .systemGreen

		// Enable Done button
		self.navigationItem.rightBarButtonItem?.isEnabled = true

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {

			// Back to foremer VC
			self.navigationController?.popViewController(animated: true)
		}



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
