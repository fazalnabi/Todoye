//
//  ViewController.swift
//  Todoye
//
//  Created by APPLE on 1/21/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class TodoyeListViewController: UITableViewController {

    
    var itemArray = ["Buy Eggs","Hair Cutting","Buy Books"]
    //persistant data storage
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
            itemArray = items
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //checking if row is checked then remove checkmark otherwise add checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ITem", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
        
            textField.placeholder = "Create New Item"
            
            myTextField = textField
        }
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user click add item
        
           // print(myTextField.text!)
            
            self.itemArray.append(myTextField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
         }
        
        let action1 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(action1)
        
        //showing alert dialog
        present(alert, animated: true, completion: nil)
        
    }
    
}

