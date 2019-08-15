//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Kavisha on 15/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var listCategory = ["Shopping", "Movie"];
    
    var categoryList : [Category] = [Category]();
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadCategories();
    }

    //MARK: - Add TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryList.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        cell.textLabel?.text = categoryList[indexPath.row].name;
        
        return cell;
    }
    
    
    //Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! TodoListViewController;
        
        let indextPath = tableView.indexPathForSelectedRow;
        
        if let path = indextPath {
            let row = path.row;
            let cat = categoryList[row];
            //print("Selected category \(cat.name!)");
            destination.selectedCategory = cat;
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userEnteredTextField = UITextField();
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let userEnteredCategory = userEnteredTextField.text!;
            self.listCategory.append(userEnteredCategory);
            
            let category = Category(context: self.context);
            category.name = userEnteredCategory;
  
            self.categoryList.append(category);
            self.saveData();
        }
        
        alert.addAction(action);
        
        alert.addTextField {
            (textField) in
            userEnteredTextField = textField;
        }
        present(alert, animated: true, completion: nil);
    }
    
    func saveData() {
        do {
            try context.save();
        } catch {
            print("Error obtained while saving data \(error)")
        }
        
        self.tableView.reloadData();
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest();
        
        do {
            let categories = try context.fetch(request);
            categoryList = categories;
            
        } catch {
            print("Error fetching data \(error)");
        }
        self.tableView.reloadData();
    }
    
    

}
