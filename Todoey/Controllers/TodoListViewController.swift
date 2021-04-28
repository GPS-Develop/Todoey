
import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    //Concept called context, and this goes into the app delegate and grabs the persistent container, and then we grab a reference to the context for that persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                loadItems()
        
    }
    
    // creates the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //For example, if I click on this first row, then the index path dot row would be equal to zero, and I would go inside the item array which we know is a array of NS managed objects, and I would retrieve the first item inside that array, and then I would modify its done property or done attribute to be the opposite of what it used to be so True to False, false to true. And then I commit those changes, by using the Save items method, which simply commits the current state of the context, with the updated attribute to a persistent container.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //deleting from database order matters!!!
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
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
            
            // add a new item to our table view, we create a new object of type item, and remember this class gets automatically generated when we create a new entity with that name inside our data model and that class already has access to all the properties that we have specified and attributes title and done so we create a new item, and that item is an object of type, NS managed object
            let newItem = Item(context: self.context)
            newItem.title = alertText.text!
            newItem.done = false
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
        
        do {
            try context.save()
        }catch{
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
}
