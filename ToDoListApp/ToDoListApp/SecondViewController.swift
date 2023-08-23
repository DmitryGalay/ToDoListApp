//
//  SecondViewController.swift
//  ToDoListApp
//
//  Created by Dima on 21.08.23.
//

import Foundation

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    
    func secondViewController(_ vc: SecondViewController, didSaveTodo todo: Todo)
}

class SecondViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var todo: Todo?
    weak var delegate: SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = todo?.title
    }
    
    @IBAction func didTapSaveAction(_ sender: Any) {
        let todo = Todo(title: textField.text!)
        delegate?.secondViewController(self, didSaveTodo: todo)
    }
}
