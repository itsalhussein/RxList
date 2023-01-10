//
//  AddTaskViewController.swift
//  RxList
//
//  Created by Hussein Anwar on 10/01/2023.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController:UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Actions
    @IBAction func saveAction() {
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
              let title = self.taskTextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        
    }
    
}
