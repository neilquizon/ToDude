//
//  ItemListViewController.swift
//  ToDude
//
//  Created by Neil Quizon on 2020-03-05.
//  Copyright © 2020 Neil Quizon. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // the quick brown fox jumped over the head of the lazy dog
    
    var items = [Item]()

    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        var tempTextField = UITextField()
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .default) { (action) in
            let newItem = Item(context: self.context)
            if let text = tempTextField.text {
              newItem.title = text
              newItem.completed = false
              self.items.append(newItem)
              self.saveItems()
            }
        }
    
              
              alertController.addTextField { (textField) in
                textField.placeholder = "Title"
                tempTextField = textField
              }
              
              alertController.addAction(alertAction)
              // show our alert on screen
              present(alertController, animated: true, completion: nil)
        
            }

            func saveItems() {
              do {
                try context.save()
              } catch {
                print("Error saving context \(error)")
              }
              tableView.reloadData()
            }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        // Configure the cell...
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
      
        // toggle completed
        item.completed = !item.completed
    }
    
    
}
