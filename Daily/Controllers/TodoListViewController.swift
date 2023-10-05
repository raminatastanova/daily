//
//  ViewController.swift
//  Daily
//
//  Created by Ramina Tastanova on September 2023.
//

import UIKit
import CoreData
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    var itemArray = [Item]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory: Category? {
        
        /*everything that's between these curly braces is going
         to happen as soon as selected category gets set with a value.*/
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            let theColourWeAreUsing = UIColor(hexString: colorHex)!
            
            
            searchBar.barTintColor = theColourWeAreUsing
            let navBarAppearance = UINavigationBarAppearance()
            let navBar = navigationController?.navigationBar
            let navItem = navigationController?.navigationItem
            navBarAppearance.configureWithOpaqueBackground()
            let contrastColour = ContrastColorOf(theColourWeAreUsing, returnFlat: true)
            
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .systemBlue
            
            navItem?.rightBarButtonItem?.tintColor = .white
            navBar?.tintColor = contrastColour
            navBar?.standardAppearance = navBarAppearance
            navBar?.scrollEdgeAppearance = navBarAppearance
            
            
            self.navigationController?.navigationBar.setNeedsLayout()
        }
        
        
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if let categoryColor = UIColor(hexString: selectedCategory!.color!)?.darken(byPercentage: CGFloat(indexPath.row)*0.4/CGFloat(itemArray.count)) {
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        cell.tintColor = UIColor.systemBlue
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    //MARK: - TableView Delegate Methods
    //used delegate method to detect which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController (title: "Add New Daily Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen when user clicks Add Item Button on UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            //to be able to use alertTextField outside this closure
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate?  = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        self.context.delete(self.itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
    }
}
//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            //loadItems()
            return
        }
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
        }else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
}


