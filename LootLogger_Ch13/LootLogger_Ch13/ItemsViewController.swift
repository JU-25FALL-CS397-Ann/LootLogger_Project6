//
//  ItemsViewController.swift
//  LootLogger_Ch12
//
//  Created by Ann Ubaka on 11/5/25.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    // MARK: - Bronze Challenge: Computed properties for sectioned items
    var expensiveItems: [Item] {
        return itemStore.allItems.filter { $0.valueInDollars >= 50 }
    }
    
    var inexpensiveItems: [Item] {
        return itemStore.allItems.filter { $0.valueInDollars < 50 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        // Register custom cell for better display
        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        title = "LootLogger"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // Chapter 13 Silver Challenge: Return 1 section if no items, otherwise 2
    override func numberOfSections(in tableView: UITableView) -> Int {
        if itemStore.allItems.isEmpty {
            return 1  // Show "No items!" section
        }
        return 2
    }
    
    // Chapter 13 Silver Challenge: Handle "No items!" row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemStore.allItems.isEmpty {
            return 1  // Show one "No items!" row
        }
        
        switch section {
        case 0:
            return expensiveItems.count
        case 1:
            return inexpensiveItems.count
        default:
            return 0
        }
    }
    
    // Chapter 12: Use custom ItemCell
    // Chapter 13 Silver Challenge: Show "No items!" when empty
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Handle empty state
        if itemStore.allItems.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
            cell.textLabel?.text = "No items!"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item: Item
        switch indexPath.section {
        case 0:
            item = expensiveItems[indexPath.row]
        case 1:
            item = inexpensiveItems[indexPath.row]
        default:
            fatalError("Invalid section")
        }
        
        cell.configure(for: item)
        return cell
    }
    
    // Bronze Challenge: Optional section headers
    // Chapter 13 Silver Challenge: No header when empty
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if itemStore.allItems.isEmpty {
            return nil
        }
        
        switch section {
        case 0:
            return "Items worth $50 or more (\(expensiveItems.count) items)"
        case 1:
            return "Items worth less than $50 (\(inexpensiveItems.count) items)"
        default:
            return nil
        }
    }
    
    // Chapter 12 Bronze Challenge: Navigation to DetailViewController
    // Chapter 13 Silver Challenge: Don't allow selection of "No items!" row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Don't navigate if showing "No items!" row
        if itemStore.allItems.isEmpty {
            return
        }
        
        let item: Item
        switch indexPath.section {
        case 0:
            item = expensiveItems[indexPath.row]
        case 1:
            item = inexpensiveItems[indexPath.row]
        default:
            return
        }
        
        let detailViewController = DetailViewController()
        detailViewController.item = item
        detailViewController.imageStore = imageStore
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // Chapter 13 Silver Challenge: Prevent editing of "No items!" row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // "No items!" row cannot be edited
        return !itemStore.allItems.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item: Item
            switch indexPath.section {
            case 0:
                item = expensiveItems[indexPath.row]
            case 1:
                item = inexpensiveItems[indexPath.row]
            default:
                return
            }
            
            // Remove the item from the store
            itemStore.removeItem(item)
            
            // Remove the image from the image store
            imageStore.deleteImage(forKey: item.itemKey)
            
            // Chapter 13 Silver Challenge: Check if we need to show "No items!" row
            if itemStore.allItems.isEmpty {
                // Reload to show "No items!" row
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @objc func addNewItem(_ sender: UIBarButtonItem) {
        // Chapter 13 Silver Challenge: Check if transitioning from empty to non-empty
        let wasEmpty = itemStore.allItems.isEmpty
        
        let newItem = itemStore.createItem()
        
        if wasEmpty {
            // Reload entire table to remove "No items!" and show sections
            tableView.reloadData()
        } else {
            // Determine which section the new item belongs to and reload that section
            let targetSection = newItem.valueInDollars >= 50 ? 0 : 1
            let targetItems = targetSection == 0 ? expensiveItems : inexpensiveItems
            let newIndexPath = IndexPath(row: targetItems.count - 1, section: targetSection)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}

