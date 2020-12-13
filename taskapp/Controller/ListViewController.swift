//
//  ListViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/08.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

final class ListViewController: UIViewController {


	// MARK: - IBOutlet


	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var categoryNamePicker: UIPickerView!
	

	// MARK: - Stored Property


	// Get instance of Realm
	private let realm = try! Realm()

	// List array that stores task in DB
	private var taskList: Results<Task> = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)

	private var categoryList: Results<Category> = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: true)


	// MARK: - LifeCycle


    override func viewDidLoad() {
        super.viewDidLoad()

		// Conform to protocol
		self.searchBar.delegate = self
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.categoryNamePicker.dataSource = self
		self.categoryNamePicker.delegate = self
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Reflect updated task datas into tableview
		self.tableView.reloadData()
	}


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		// Get reference to destination
		let inputVC = segue.destination as! InputViewController

        // Divide case by element that user tapped
		if segue.identifier  == C.SEGUE_ID_FROM_CELL {
			// <Tapped cell>

			// Get reference to index path for selected cell
			if let indexPath = self.tableView.indexPathForSelectedRow {

				// Get a task object corresponding to selected cell
				let task = self.taskList[indexPath.row]

				// Assign given task obj into destination's task property
				inputVC.task = task
			}
		} else {
			// <Tapped add button>

			// Initialize new blank task object
			let task = Task()

			// Get all objects in realm
			let allTask = self.realm.objects(Task.self)

			// Create new id for blank task
			if allTask.count != 0 {


				let newID = allTask.max(ofProperty: "id")!
					+ 1

				// Assign new id into blank task
				task.id = newID
			}

			// Assign task obj into destination's task property
			inputVC.task = task
		}
    }

	

}// MARK: - Endline


// MARK: - Protocol Method
// MARK: - UITableViewDataSource


extension ListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		// Number of task in DB
		return self.taskList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		// Get cell reusable
		let cell = tableView.dequeueReusableCell(withIdentifier: C.CELL_ID, for: indexPath)

		// Set title into cell from Task object
		cell.textLabel?.text = self.taskList[indexPath.row].title

		// Get converted Date into String
		let date = self.taskList[indexPath.row].date
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"
		let dateString: String = formatter.string(from: date)
		// FIXME: - Get category's name
		// Get category string value from the task
		let categoryString = self.taskList[indexPath.row].category?.name

		// Set date & category into cell's datail label
		cell.detailTextLabel?.text = "\(dateString)・\(categoryString!)"

		// Return configured cell
		return cell
	}

	// Execute when deletion is occured by user's editing
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		// Confirm editing style
		if editingStyle != .delete {
			return
		}

		// Get task tobe deleted
		let task = self.taskList[indexPath.row]

		// <Cancel local notificaion for the cell>
		// 1. Get reference to UN center
		let center = UNUserNotificationCenter.current()

		// 2. Remove notification that corresponds to task tobe deleted
		center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

		// <Dealing with database for deletion>
		try! self.realm.write {

			// 1. Delete Corresponding task object from DB
			self.realm.delete(task)

			// 2. Animate deletion
			tableView.deleteRows(at: [indexPath], with: .fade)
		}

		// Log remaining pending notifications
		center.getPendingNotificationRequests { (requests) in
			for request in requests {
				print("/-----------")
				print(request)
				print("-----------/")
			}
		}
	}


}// Endline


// MARK: - UITableViewDelegate


extension ListViewController: UITableViewDelegate {


	// Execute when user tapped the cell
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// Navigate to editing screen
		self.performSegue(withIdentifier: C.SEGUE_ID_FROM_CELL, sender: self)
	}

	// Setting for the cell can be delete
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

		// Add delete function to each cell
		return .delete
	}


}


// MARK: - UISearchBarDelegate Method


extension ListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		// Divide case the search bar contains text or not
		if searchBar.text != "" {

			// <Perform filtering to all task object>

			// 1. Get reference to all Task object in Realm
			let allTask = self.realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)

			// 2. Get result of filtering category with input text
			let result = allTask.filter("category.name CONTAINS %@", searchBar.text!)

			// 3. Assign result into array
			self.taskList = result

		} else {

			// RE-assign plane task objects
			self.taskList = self.realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
		}

		// Dismiss keyboard and end editing
		self.searchBar.endEditing(true)

		// Refresh table view after filering
		self.tableView.reloadData()
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

		// Trigger reload when search text is empty
		if searchText == "" {
			// RE-assign plane task objects
			self.taskList = self.realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)

			// Refresh table view
			self.tableView.reloadData()
		}
	}

	
}


// MARK: - UIPickerViewDataSource Method


extension ListViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		return self.categoryList.count
	}
}


// MARK: - UIPickerViewDelegate Method


extension ListViewController: UIPickerViewDelegate {


	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		return self.categoryList[row].name

	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		// Set row title into seach bar
		self.searchBar.text = self.categoryList[row].name

		// Perform searching
		self.searchBarSearchButtonClicked(self.searchBar)
	}

}
