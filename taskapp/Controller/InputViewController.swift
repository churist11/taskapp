//
//  InputViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/08.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift

final class InputViewController: UIViewController {

	// MARK: - IBOutlet


	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var datePicker: UIDatePicker!


	// MARK: - Instance Property


	// Get instance value from Realm
	private let realm = try! Realm()

	// Guaranteed tobe assigned value
	internal var task: Task!


	// MARK: - LifeCycle


	override func viewDidLoad() {
		super.viewDidLoad()

		// Reflect task properties into UI compornents
		self.titleTextField.text = self.task.title
		self.contentsTextView.text = self.task.contents
		self.datePicker.date = self.task.date
	}

	// Deal with database about input before back to list
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// Update realm to add new / edited task
		try! self.realm.write {

			// Configure task object
			self.task.title = self.titleTextField.text!
			self.task.contents = self.contentsTextView.text
			self.task.date = self.datePicker.date

			// Save task in realm
			self.realm.add(self.task, update: .modified)
		}

	}

}// MARK: - Endline
