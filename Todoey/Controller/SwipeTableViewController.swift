//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Kavisha on 19/08/19.
//  Copyright © 2019 SoKa. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80;
    }
    
    //MARK:- Table view datasoure methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell;
        cell.delegate = self;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
            
            /*if let list = self.categoryList {
             
                //let index = indexPath.row;
                let categoryToBeDeleted = list[index];
                print("Item that will be deleted is \(categoryToBeDeleted.name)");
                
                self.delete(with: categoryToBeDeleted)
            }
            print("Item deleted"); */
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    /*func delete(with category : Category) {
        do {
            try self.realm.write {
                self.realm.delete(category);
            }
        } catch {
            print("Error ocurred while deleting an item \(error)")
        }
        //self.tableView.reloadData();
    } */
    
    func updateModel(at indexPath : IndexPath) {
        print("Add the update model steps here.")
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

   
}
