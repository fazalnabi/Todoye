

import UIKit
import CoreData

class TodoyeListViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        
        didSet{
            loadItems()
        }
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        /*
        for deleting items from Table view and CoreData we first delete item
        from CoreData and then from table view and after that save the context to commit changes in the CoreData otherwise app will crash*/
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
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
        

            let newItem = Item(context: self.context)
            newItem.title = myTextField.text!
            newItem.done = false
            newItem.category = self.selectedCategory
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
        do{
      
            try context.save()
        }
        catch{
            print("Error saving context : \(error)")
        }
    }
    
    /*
     "with" is an outer parameter and is used at the time of calling function and expression after "=" is used as default value if we do no pass parameter to the function at the time of calling */
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){

        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
           itemArray =  try context.fetch(request)
        }
        catch{
            print("Error while retreiving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Search Bar delegate method
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //for adding condition like where clause in mysql
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        //sorting data in ascending order
        let sorDiscriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sorDiscriptor]
        
        loadItems(with : request, predicate: predicate)
        

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

