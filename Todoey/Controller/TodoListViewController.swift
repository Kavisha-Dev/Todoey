//
//  ViewController.swift
//  Todoey
//
//  Created by Kavisha on 14/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var listItem = [Item]();
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    let defaults = UserDefaults.standard;
    
    var selectedCategory : Category? {
        didSet {
            loadItems();
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems();
        
        /*if let item = defaults.array(forKey: "TodoList") as? [Item] {
            listItem = item;
        }*/
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath);
        let item = listItem[indexPath.row];
        
        cell.textLabel?.text = item.title;
        cell.accessoryType = item.done == true ? .checkmark : .none;
        return cell;
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listItem[indexPath.row].done = !listItem[indexPath.row].done;
        self.saveData();
    
        //context.delete(listItem[indexPath.row])
        
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK: - Add a new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField();
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (UIAlertAction) in
            
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
            let newItem = Item(context: self.context);
            newItem.title = itemTextField.text!;
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory;
            self.listItem.append(newItem);
            
            self.saveData()
        }
        
        alert.addTextField {
            (textField) in
            itemTextField = textField;
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
        
    }
    
    func saveData() {
        do {
            try context.save();
            print("New item saved");
        } catch {
            print("error saving data \(error)")
        }
        
        /*let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(listItem);
            try data.write(to: filePath!)
        } catch {
            print("Error encoding value \(error)")
        } */
        
        self.tableView.reloadData();
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest();
        
        let categoryPredicate : NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);

        var predicates : [NSPredicate] = [categoryPredicate];
        
        if let searchPredicate = request.predicate {
            predicates.append(searchPredicate);
        }
        
        let andPredicate : NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates);
        request.predicate = andPredicate;
        
        print("Selected category is \(selectedCategory!.name!)")
        
        do {
            listItem = try context.fetch(request);
        } catch {
            print("Error reading the data \(error)")
        }
        tableView.reloadData();
    }

}

//Mark: - Search Bar delegate methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        
        let predicate : NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //let categoryPredicate : NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);
        
        //let andPredicate : NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
        
        request.predicate = predicate;
        
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true);
        request.sortDescriptors = [sortDescriptor];
        
        loadItems(with: request)
        print(searchBar.text!);
    }
    
    
    //When the text field is cleared out
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems();
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelled clicked");
    }
}

