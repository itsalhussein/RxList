//
//  TaskListViewController.swift
//  RxList
//
//  Created by Hussein Anwar on 10/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController : UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
     
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension TaskListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        cell.title.text = self.filteredTasks[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTaskVC = navC.viewControllers.first as? AddTaskViewController else { return }
        
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
     
        if priority == nil {
            self.filteredTasks = self.tasks.value
            updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
                print("TASKS IN FILTER TASKS BY PRIORITY : ",tasks)
            }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
}
