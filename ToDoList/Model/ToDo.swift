//
//  ToDo.swift
//  ToDoList
//
//  Created by Alexander on 08/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

@objcMembers class ToDo: NSObject {
    var title: String
    var image: UIImage?
    var dueDate: Date
    var isComplete: Bool
    var notes: String?
    
    
    init(title: String = "",
         isComplete: Bool = false,
         dueDate: Date = Date(),
         notes: String? = nil,
         image: UIImage? = nil) {
        
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.image = image
    }
    
    var capitalizedKeys: [String] {
        return keys.map { $0.capitalizedWithSpaces }
    }
    
    var keys: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any] {
        return Mirror(reflecting: self).children.map { $0.value }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self.dueDate)
    }
    
    override func copy() -> Any {
        return ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes, image: image)
    }
}


