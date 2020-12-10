//
//  InputViewController.swift
//  taskapp
//
//  Created by 櫻井将太郎 on 2020/12/08.
//  Copyright © 2020 shoutarou.sakurai. All rights reserved.
//

import UIKit

final class InputViewController: UIViewController {

	// MARK: - IBOutlet



	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var datePicker: UIDatePicker!


	// MARK: - Instance Property


	internal var task: Task?


	// MARK: - LifeCycle


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	// Deal with database about input before back to list
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

}// MARK: - Endline
