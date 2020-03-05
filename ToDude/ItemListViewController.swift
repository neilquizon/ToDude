//
//  ItemListViewController.swift
//  ToDude
//
//  Created by Neil Quizon on 2020-03-05.
//  Copyright © 2020 Neil Quizon. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit


class ItemListViewController: UITableViewController {
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // the quick brown fox jumped over the head of the lazy dog
    
    var items = [Item]()
    var category: Category?

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
        tableView.rowHeight = 80.0
        loadItems()
        

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
       

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

extension ItemListViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    // initialize a SwipeAction object
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      // delete the item from our context
      self.context.delete(self.items[indexPath.row])
      // remove the item from the items array
      self.items.remove(at: indexPath.row)
      
      // save our context
      self.saveItems()
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "trash")
    
    return [deleteAction]
  }
}

extension ItemListViewController: UISearchBarDelegate {
    

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // if our search text is nil we should not execute any more code and just return
    guard let searchText = searchBar.text else { return }
    searchItems(searchText: searchText)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count > 0 {
      searchItems(searchText: searchText)
    } else if searchText.count == 0 {
      // show the full list of items
      loadItems()
    }
  }

  // this method's use is restricted to this file
  fileprivate func searchItems(searchText: String) {
    // our fetch request for items
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
    // a predicate allows us to create a filter or mapping for our items
    // [c] means ignore case
    let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
    
    // the sort descriptor allows us to tell the request how we want our data sorted
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    
    // set the predicate and sort descriptors for on the request
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // retrieve the items with the request we created
    do {
      items = try context.fetch(fetchRequest)
    } catch {
      print("Error fetching items: \(error)")
    }
    
    // reload our table with our new data
    tableView.reloadData()
  }
}
