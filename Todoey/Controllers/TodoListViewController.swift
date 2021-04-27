
import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
//
//        var newItem = Item()
//        newItem.itemName = "Find Mike"
//        itemArray.append(newItem)
//
//        var newItem2 = Item()
//        newItem2.itemName = "Find Mike2"
//        itemArray.append(newItem2)
//
//        var newItem3 = Item()
//        newItem3.itemName = "Find Mike3"
//        itemArray.append(newItem3)
        
        loadItems()
        //        //stores item in users plist
        //       if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //           itemArray = items
        //       }
    }
    
    
    
    // creates the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.itemName
        cell.accessoryType = item.checked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItems()
        
        tableView.reloadData()
        
        // Table view cell Flashes grey selection and goes back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            var newItem = Item()
            newItem.itemName = alertText.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertText = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error loading items \(error)")
            }
        }
    }
}
