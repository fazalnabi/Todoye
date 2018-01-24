//
//  ViewController.swift
//  Todoye
//
//  Created by APPLE on 1/21/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class TodoyeListViewController: UITableViewController {

    
    var itemArray = [Item]()
    //persistant data storage

    let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(dataFilePath)
        
        loadItems()
        
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title

        //checking if row is checked then remove checkmark otherwise add checkmark
        //ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.savaItem()
        tableView.reloadData()
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
        
            let newItem = Item()
            newItem.title = myTextField.text!
            self.itemArray.append(newItem)

            self.savaItem()
            
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
    
    //MARK - Model Manupulation Method
    func savaItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding item array : \(error)")
        }
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
                
            }catch {
                print("Error in decoding data \(error)")
            }
        }
    }
    
    
}

