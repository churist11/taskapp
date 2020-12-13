//
//  InputViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/08.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

final class InputViewController: UIViewController {


	// MARK: - IBOutlet


	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var categoryNamePicker: UIPickerView!
	@IBOutlet weak var datePicker: UIDatePicker!


	// MARK: - Stored Property


	// Get instance value from Realm
	private let realm = try! Realm()

	// Guaranteed tobe assigned value
	internal var task: Task!

	private var categoryList: Results<Category> = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: true)


	// MARK: - LifeCycle


	override func viewDidLoad() {
		super.viewDidLoad()

		// Assgin self to text field's delegate
		self.titleTextField.delegate = self
		// Assgin self to picker view's datasource, delegate
		self.categoryNamePicker.dataSource = self
		self.categoryNamePicker.delegate = self

		// Add tap gesture into view
		let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		self.view.addGestureRecognizer(tapGesture)

		// Reflect task's properties into UI compornents
		self.titleTextField.text = self.task.title
		self.contentsTextView.text = self.task.contents
		self.datePicker.date = self.task.date
	}

	// When back from EditCategory screen
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Execute when the task already have category
		if let category = self.task.category {

			// Reflect updated data in picker view
			self.categoryNamePicker.reloadComponent(0)

			// Get index of selected category
			let index = category.id

			// Auto select row corresponding to the task's category
			self.categoryNamePicker.selectRow(index, inComponent: 0, animated: false)
		}
	}


	// MARK: - IBAction
	

	// Deal with database about input before back to list
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {

		// Update realm to add new / edited task
		try! self.realm.write {

			// Configure task object
			self.task.title = self.titleTextField.text!
			self.task.contents = self.contentsTextView.text
			
			// <Get text picker current presents>
			// 1. Get index fo selected row in picker
			let index = self.categoryNamePicker.selectedRow(inComponent: 0)

			// 2. Set category obj from array
			self.task.category = self.categoryList[index]

			// Set date
			self.task.date = self.datePicker.date

			// Save task in realm
			self.realm.add(self.task, update: .modified)
		}

		// Resister custom notification into Realm
		self.resistNotification(with: self.task)

		// Back to List VC
		self.navigationController?.popViewController(animated: true)
	}


	// MARK: - Navigation
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		// Confirm segue id
		guard segue.identifier == C.SEGUE_ID_ADD_CATEGORY else {
			return
		}

		// Get reference to EditCategory VC
		if let editCategoryVC = segue.destination as? EditCategoryViewController {

			// Send the task editing now
			editCategoryVC.task = self.task
		}
	}


	// MARK: - Obj-c Method


	@objc private func dismissKeyboard() -> Void {
		self.view.endEditing(true)
	}


	// MARK: - Instance Property


	private func resistNotification(with task: Task) -> Void {

		// Initialize blank notification content
		let unContent = UNMutableNotificationContent()

		// Configure content: title, body, sound
		unContent.title = (self.task.title == "") ? "(No Title)" : self.task.title
		unContent.body = (self.task.contents ==  "") ? "(No Content)" : self.task.contents
		// FIXME: - Set subtitle from category name
		unContent.subtitle = (self.task.category?.name == "") ? "(No category)" : "category: \(self.task.category!.name)"

		unContent.sound = UNNotificationSound.default

		// <Create date trigger>
		// 1.Choose components from date the task has
		let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.task.date)

		// 2.Create trigger from components
		let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

		// Create UN requrst from content, trigger, taskID
		let request = UNNotificationRequest(identifier: String(task.id), content: unContent, trigger: dateTrigger)

		// <Resist request into UNcenter>
		// 1.Get current center
		let unCenter = UNUserNotificationCenter.current()

		// 2.Add the request and set handler that log error message.
		unCenter.add(request) { (error) in
			print(error ?? "Resister successed.")
		}

		// Log notification that not notified yet.
		unCenter.getPendingNotificationRequests { (requests) in
			for request in requests {
				print("/--------")
				print(request)
				print("--------/")
			}
		}
	}
	

}// MARK: - Endline


// MARK: - UITextFieldDelegate Method


extension InputViewController: UITextFieldDelegate {

	// Allow return action
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		// End editing
		textField.endEditing(true)
		return true
	}

}


// MARK: - UIPickerViewDataSource Method


extension InputViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		return self.categoryList.count
	}
}


// MARK: - UIPickerViewDelegate Method


extension InputViewController: UIPickerViewDelegate {


	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		return self.categoryList[row].name

	}
	
}
