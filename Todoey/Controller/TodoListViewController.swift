//
//  ViewController.swift
//  Todoey
//
//  Created by Kavisha on 14/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //var listItem = [Item]();
    var listItem : Results<Item>?
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    let realm = try! Realm();
    
    let defaults = UserDefaults.standard;
    
    /*var cat : LinkingObjects<Category>? {
        didSet {
            loadItemsFromRealm();
        }
    } */
    
    var selectedCategory : Category? {
        didSet {
            //loadItems()
            
            loadItemsFromRealm();
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
        return listItem?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let item = listItem[indexPath.row];
        cell.textLabel?.text = item.title;
        cell.accessoryType = item.done == true ? .checkmark : .none; */
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath);
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = listItem?[indexPath.row] {
            cell.textLabel?.text = item.title;
            cell.accessoryType = item.done == true ? .checkmark : .none;
           // HexColor(selectedCategory!.colour)?.darken(byPercentage: <#T##CGFloat#>)
            
            if let color = FlatWhite().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(listItem!.count)) {
                 cell.backgroundColor = color;
                 cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
           
        } else {
            cell.textLabel?.text = "No item added yet" ;
        }
        return cell;
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //context.delete(listItem[indexPath.row])
        //listItem[indexPath.row].done = !listItem[indexPath.row].done;
        
        if let item = listItem?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done;
                    
                    //Inorder for the delete to happen
                    //realm.delete(item);
                }
            } catch {
                print("Error updating the done value \(error)");
            }
        }
        
        //self.saveData();
        
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK: - Add a new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField();
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (UIAlertAction) in

//            let newItem = Item(context: self.context);
//            newItem.title = itemTextField.text!;
//            newItem.done = false;
//            newItem.parentCategory = self.selectedCategory;
//            self.listItem.append(newItem);
//            self.saveData()
        
            do {
                try self.realm.write {
                    /* if i create an Object like this and then add it, it gets saved on the db But in the Category the linkage with the object doesnot get added.
                        In order for thet to get added we need to add the entire code inside the write block and need not add a 'add'.
                        The append here does this.
                        Correction it, adds it to the items database but not the items database for the category. Using the append adds it to both the category database and the items database. */
                    //self.realm.add(newItem);
                    
                    let newItem = Item()
                    newItem.title = itemTextField.text!;
                    //newItem.done = false;
                    
                    self.selectedCategory?.items.append(newItem)
                    print("saved the data onto Realm items")
                }
            } catch {
                print("Error saving");
            }
            self.tableView.reloadData();
        }
        
        alert.addTextField {
            (textField) in
            itemTextField = textField;
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
        
    }
    
    //Save data using Core Data
    func saveData() {
        do {
            try context.save();
            print("New item saved");
        } catch {
            print("error saving data \(error)")
        }
        
        // Writing to a plist file
        /*let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(listItem);
            try data.write(to: filePath!)
        } catch {
            print("Error encoding value \(error)")
        } */
        
        self.tableView.reloadData();
    }
    
    //Getting data using Core Data
    /*func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
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
    }*/
    
    func loadItemsFromRealm() {
        listItem = selectedCategory?.items.sorted(byKeyPath: "dateCreated" , ascending: false);
        
        tableView.reloadData();
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let list = listItem {
            
            let index = indexPath.row;
            let itemToBeDeleted = list[index];
            print("Item that will be deleted is \(itemToBeDeleted.title)");
            
            self.delete(with: itemToBeDeleted)
        }
    }
    
    func delete(with item : Item) {
        do {
            try self.realm.write {
                self.realm.delete(item);
            }
        } catch {
            print("Error ocurred while deleting an item \(error)")
        }
        //self.tableView.reloadData();
    }

}

//Mark: - Search Bar delegate methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        /*let request : NSFetchRequest<Item> = Item.fetchRequest();

        let predicate : NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        //let categoryPredicate : NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);

        //let andPredicate : NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])

        request.predicate = predicate;

        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true);
        request.sortDescriptors = [sortDescriptor];

        loadItems(with: request) */

        //Loading with Realm
        print(searchBar.text!);
        listItem = listItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false);
        
        tableView.reloadData();
    }


    //When the text field is cleared out
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            //loadItems();
            
            loadItemsFromRealm();

            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelled clicked");
    }
}

