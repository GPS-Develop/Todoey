//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gurpreet Singh on 2021-04-28.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    // we initialize a new access point to our realm Database.
    let realm = try! Realm()
    
    // We changed our categories from an array of category items to this new collection type, which is a collection of results that are category objects. And this is an optional, so that we can be safe.
    var categoryArray: Results<Category>?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateNavbarToDefault()

        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {

        updateNavbarToDefault()
    }
    
    // we set that property categoryArray to look inside our realm and fetch all of the objects that belong to the category data type, and then we reload our table view with the new data.
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // taps into the cell that gets created inside the superView @ the current indexpath from SwipeTableViewController
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        if let myHexColor = categoryArray?[indexPath.row].hexColor{
            cell.backgroundColor = UIColor(hexString: myHexColor)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: myHexColor)!, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
        
    }
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item.items)
                    self.realm.delete(item)
                }
            } catch  {
                print("Deleting category failed, \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.hexColor =  UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Resets Navbar to default blue
    
    func updateNavbarToDefault(){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.systemBlue
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    
}






