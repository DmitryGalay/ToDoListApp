//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Dima on 21.08.23.
//

import UIKit

struct Todo {
    
    let title: String
    let isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
    
    func toggle() -> Todo {
        return Todo(title: title, isComplete: !isComplete)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var todos = [
        Todo(title: "Выполненное тестовое"),
        Todo(title: "Резюме"),
        Todo(title: "Ожидания по зп."),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapDeleteAction(_ sender: Any) {
        mainTableView.isEditing = !mainTableView.isEditing
    }
    
    @IBSegueAction func didTapAddNewAction(_ coder: NSCoder) -> SecondViewController? {
        let vc = SecondViewController(coder: coder)
        
        if let indexpath = mainTableView.indexPathForSelectedRow {
            let todo = todos[indexpath.row]
            vc?.todo = todo
        }
        
        vc?.delegate = self
        vc?.presentationController?.delegate = self
        return vc
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
            let todo = self.todos[indexPath.row].toggle()
            self.todos[indexPath.row] = todo
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            cell.set(checked: todo.isComplete)
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CustomTableViewCell
        cell.delegate = self
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isComplete)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
}

extension ViewController: CustomTableViewCellDelegate {
    
    func checkTableViewCell(_ cell: CustomTableViewCell, didChagneCheckedState checked: Bool) {
        guard let indexPath = mainTableView.indexPath(for: cell) else {return}
        let todo = todos[indexPath.row]
        let newTodo = Todo(title: todo.title, isComplete: checked)
        todos[indexPath.row] = newTodo
    }
}

extension ViewController: SecondViewControllerDelegate {
    
    func secondViewController(_ vc: SecondViewController, didSaveTodo todo: Todo) { dismiss(animated: true) {
        if let indexPath = self.mainTableView.indexPathForSelectedRow {
            self.todos[indexPath.row] = todo
            self.mainTableView.reloadRows(at: [indexPath], with: .none)
        } else {
            self.todos.append(todo)
            self.mainTableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
        }
    }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = mainTableView.indexPathForSelectedRow {
            mainTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
