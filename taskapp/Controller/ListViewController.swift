//
//  ListViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/08.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit
import RealmSwift

final class ListViewController: UIViewController {


	// MARK: - IBOutlet


	@IBOutlet weak var tableView: UITableView!


	// MARK: - Stored Property

	// Get instance value from Realm
	private let realm = try! Realm()

	// List array that stores task in DB
	private var taskArray: Results<Task> = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)


	// MARK: - LifeCycle


    override func viewDidLoad() {
        super.viewDidLoad()

		// Conform to protocol
		self.tableView.dataSource = self
		self.tableView.delegate = self
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}// MARK: - Endline

// MARK: - Protocol Method
// MARK: - UITableViewDataSource


extension ListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		// TODO: - Fetch number of cell data
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		// Get cell reusable
		let cell = tableView.dequeueReusableCell(withIdentifier: C.CELL_ID, for: indexPath)

		// Return configured cell
		return cell
	}

	// Execute when deletion is occured by user's editing
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

//		// Confirm editing style
//		if editingStyle != .delete {
//			return
//		}

		// TODO: - Dealing with database for deletion

		// TODO: - Cancel local notificaion for the cell

		// TODO: - Update UI after deletion
	}


}


// MARK: - UITableViewDelegate


extension ListViewController: UITableViewDelegate {

	// Execute when user tapped the cell
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: - Perfom navigation to editing screen

		// Navigate to editing screen
		self.performSegue(withIdentifier: C.SEGUE_ID_FROM_CELL, sender: self)
	}

	// Setting for the cell can be delete
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

		// Add delete function to each cell
		return .delete
	}

}
