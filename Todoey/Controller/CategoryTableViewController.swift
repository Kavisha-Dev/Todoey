//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Kavisha on 15/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Realm


class CategoryTableViewController: UITableViewController {
    
    var listCategory = ["Shopping", "Movie"];
    
    //var categoryList : [Category] = [Category]();
    
    var categoryList : Results<Category>?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad();
        
//        loadCategories();
        
        loadCategoriesFromRealm()
    }

    //MARK: - Add TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryList?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Catgory Added Yet";
        
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
            let cat = categoryList?[row];
            //print("Selected category \(cat.name!)");
            destination.selectedCategory = cat;
            
            //destination.cat = cat;
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userEnteredTextField = UITextField();
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let userEnteredCategory = userEnteredTextField.text!;
            self.listCategory.append(userEnteredCategory);
            
            /*let newCategory = Category(context: self.context);
             newCategory = userEnteredCategory;
            self.categoryList.append(newCategory);
            self.saveData(); */
            
            let newCategory : Category = Category();
            newCategory.name = userEnteredCategory;
            
            //Do not need to append since its an auto updating container
            //self.categoryList.append(newCategory);
            
            self.saveRealm(category : newCategory);
        }
        
        alert.addAction(action);
        
        alert.addTextField {
            (textField) in
            userEnteredTextField = textField;
        }
        present(alert, animated: true, completion: nil);
    }
    
    func saveRealm(category : Category) {
        do {
            try realm.write {
                realm.add(category);
            }
        } catch {
            print("Error while saving date in Realm, error ir \(error)");
        }
        self.tableView.reloadData();
        
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
//        let request : NSFetchRequest<Category> = Category.fetchRequest();
//
//        do {
//            let categories = try context.fetch(request);
//            categoryList = categories;
//
//        } catch {
//            print("Error fetching data \(error)");
//        }
//        self.tableView.reloadData();
    }
    
    func loadCategoriesFromRealm() {
      categoryList = realm.objects(Category.self)
    }
    
    

}
