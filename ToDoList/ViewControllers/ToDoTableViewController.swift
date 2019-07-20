//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Alexander on 10/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos = [
            ToDo(title: "Buy iphone xs", image: UIImage(named: "image_iphoneXS")),
            ToDo(title: "Programming on swift", image: UIImage(named: "image_swift")),
            ToDo(title: "Meditating", image: UIImage(named: "image_meditating_buddha"))
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.formattedDate
        cell.imageView?.image = todo.image
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ToDoItemSegue" else { return }
        guard let destination = segue.destination as? ToDoItemTableViewController else { return }
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        destination.todo = todos[selectedIndex.row].copy() as! ToDo
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveSegue" else { return }
        guard let source = segue.source as? ToDoItemTableViewController else { return }
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        todos[selectedIndex.row] = source.todo
        
        tableView.reloadRows(at: [selectedIndex], with: .automatic)
    }
}
