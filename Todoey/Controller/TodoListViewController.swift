//
//  ViewController.swift
//  Todoey
//
//  Created by Kavisha on 14/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var listItem = ["Find Mike" , "Buy Eggos" , "Run"]
    
    var listItem = [Item]();
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist");
    
    let defaults = UserDefaults.standard;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadItems();
        
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
        
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK: - Add a new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField();
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (UIAlertAction) in
            
            let newItem = Item();
            newItem.title = itemTextField.text!;
            self.listItem.append(newItem);
            
//           self.defaults.set(self.listItem, forKey: "TodoList")
            
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
        
        let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(listItem);
            try data.write(to: filePath!)
        } catch {
            print("Error encoding value \(error)")
        }
        
        self.tableView.reloadData();
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: filePath!) {
            
            let decoder = PropertyListDecoder();
            
            do {
            listItem = try decoder.decode([Item].self, from: data);
            } catch {
                print("error ocurred while decoding \(error)");
            }
        }
        
    }

}

