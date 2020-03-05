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
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

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
        saveItems()
    }
    
    func saveItems() {
              do {
                try context.save()
              } catch {
                print("Error saving context \(error)")
              }
              tableView.reloadData()
            }
    
    func loadItems() {
      // create a new fetch request of type NSFetchRequest<Item> - you must provide a type
      let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
      
      do {
        items = try context.fetch(fetchRequest)
      } catch {
        print("Error fetching items: \(error)")
      }
      tableView.reloadData()
    }
    
    
}
