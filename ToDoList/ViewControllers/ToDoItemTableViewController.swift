//
//  ToDoItemTableViewController.swift
//  ToDoList
//
//  Created by Alexander on 10/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {
    var todo = ToDo()
}

// MARK: - UITableViewDataSource
extension ToDoItemTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        return value is Date ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = todo.values[indexPath.section]
        let cell = getCellFor(indexPath: indexPath, with: value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todo.keys[section].capitalizedWithSpaces
    }
}

// MARK: - UITableViewDelegate
extension ToDoItemTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = todo.values[indexPath.section]
        
        if value is UIImage { return 200 }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.isHidden ? 0 : UITableView.automaticDimension
        } else {
            return value is Date && indexPath.row == 1 ? 0 : UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let value = todo.values[section]
        
        if value is Date {
            let datePickerIndexPath = IndexPath(row: 1, section: section)
            let cell = tableView.cellForRow(at: datePickerIndexPath) as! DatePickerCell
            cell.isHidden.toggle()

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if value is UIImage {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            let alertController = UIAlertController(title: "Choose image source!", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            //add photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { _ in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
                alertController.addAction(photoLibraryAction)
            }
            
            //add camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
                alertController.addAction(cameraAction)
            }
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController {
    func getCellFor(indexPath: IndexPath, with value: Any? ) -> UITableViewCell {
        if let stringValue = value as? String {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.text = stringValue
            cell.textField.section = indexPath.section
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
            return cell
            
        } else if let dateValue = value as? Date {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
                cell.setDate(dateValue)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
                cell.datePicker.date = dateValue
                cell.datePicker.section = indexPath.section
                cell.datePicker.minimumDate = Date()
                cell.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
                return cell
            default:
                fatalError("Add more prototype cells for Date section")
            }
            
        } else if let imageValue = value as? UIImage {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.largeImageView.image = imageValue
            return cell
            
        } else if let boolValue = value as? Bool {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switch.isOn = boolValue
            cell.switch.section = indexPath.section
            cell.switch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.text = ""
            cell.textField.section = indexPath.section
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
            return cell
        }
    }
}

// MARK: - Actions
extension ToDoItemTableViewController {
    @objc func datePickerValueChanged(_ sender: SectionDatePicker) {
        let key = todo.keys[sender.section]
        let value = sender.date
        todo.setValue(value, forKey: key)
        
        //update date label
        let labelIndexPath = IndexPath(row: 0, section: sender.section)
        tableView.reloadRows(at: [labelIndexPath], with: .automatic)
    }
    
    @objc func switchValueChanged(_ sender: SectionSwitch) {
        let key = todo.keys[sender.section]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
    }
    
    @objc func textFieldValueChanged(_ sender: SectionTextField) {
        let key = todo.keys[sender.section]
        let value = sender.text ?? ""
        todo.setValue(value, forKey: key)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ToDoItemTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        guard let value = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let key = todo.keys[selectedIndexPath.section]
        todo.setValue(value, forKey: key)
        
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
}

