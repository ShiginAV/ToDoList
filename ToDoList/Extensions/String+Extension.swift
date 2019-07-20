//
//  String+Extension.swift
//  ToDoList
//
//  Created by Alexander on 08/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

extension String {
    var capitalizedWithSpaces: String {
        let withSpaces = reduce("") { result, character in
            character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        return withSpaces.capitalized
    }
}
