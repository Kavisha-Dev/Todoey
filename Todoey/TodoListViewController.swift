//
//  ViewController.swift
//  Todoey
//
//  Created by Kavisha on 14/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var listItem = ["Find Mike" , "Buy Eggos" , "Run"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath);
        cell.textLabel?.text = listItem[indexPath.row];
        return cell;
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listItem[indexPath.row]);
         
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            //Remove a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        } else {
            //Add a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK: - Add a new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField();
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (UIAlertAction) in
            self.listItem.append(itemTextField.text!);
            
            self.tableView.reloadData();
        }
        
        alert.addTextField {
            (textField) in
            itemTextField = textField;
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
        
    }

}

