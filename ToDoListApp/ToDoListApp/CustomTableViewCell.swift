//
//  CustomTableViewCell.swift
//  ToDoListApp
//
//  Created by Dima on 23.08.23.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    
    func checkTableViewCell(_ cell: CustomTableViewCell, didChagneCheckedState checked: Bool)
}

class CustomTableViewCell: UITableViewCell {
    
    weak var delegate: CustomTableViewCellDelegate?
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkbox: Checkbox!
    
    func set(title: String, checked: Bool) {
        label.text = title
        set(checked: checked)
    }
    
    func set(checked: Bool) {
        checkbox.checked = checked
        updateChecked()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateChecked() {
        let attributedString = NSMutableAttributedString(string: label.text!)
        if checkbox.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        label.attributedText = attributedString
    }

    @IBAction func didTapChecked(_ sender: Checkbox) {
        updateChecked()
                delegate?.checkTableViewCell(self, didChagneCheckedState: checkbox.checked)
    }
    
}
