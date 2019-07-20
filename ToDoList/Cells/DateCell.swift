//
//  DateCell.swift
//  ToDoList
//
//  Created by Alexander on 11/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        label.text = formatter.string(from: date)
    }
}
