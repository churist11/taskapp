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
	@IBOutlet weak var datePicker: UIDatePicker!


	// MARK: - Instance Property


	// Get instance value from Realm
	private let realm = try! Realm()

	// Guaranteed tobe assigned value
	internal var task: Task!


	// MARK: - LifeCycle


	override func viewDidLoad() {
		super.viewDidLoad()

		// Add tap gesture into view
		let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		self.view.addGestureRecognizer(tapGesture)

		// Reflect task's properties into UI compornents
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

		// Resister custom notification into Realm
		self.resistNotification(with: self.task)

	}

	@objc private func dismissKeyboard() -> Void {
		self.view.endEditing(true)
	}

	private func resistNotification(with task: Task) -> Void {

		// Initialize blank notification content
		let unContent = UNMutableNotificationContent()

		// Configure content: title, body, sound
		if self.task.title == "" {
			unContent.title = "(No Title)"
		} else {
			unContent.title = self.task.title
		}

		if self.task.contents ==  "" {
			unContent.body = "(No Content)"
		} else {
			unContent.body = self.task.contents
		}

		unContent.sound = UNNotificationSound.default

		// <Create date trigger>
		// 1.Choose components from date the task has
		let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.task.date)

		// 2.Create trigger from components
		let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

		// Create UN requrst from content, trigger, taskID
		let request = UNNotificationRequest(identifier: String(self.task.id), content: unContent, trigger: dateTrigger)

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
