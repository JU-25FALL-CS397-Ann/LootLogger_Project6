//
//  ItemsViewController.swift
//  LootLogger_Ch15
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
    
    // Bronze Challenge: Return 2 sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Bronze Challenge: Return count for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
            
            // Chapter 15: Also remove the image from disk
            imageStore.deleteImage(forKey: item.itemKey)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func addNewItem(_ sender: UIBarButtonItem) {
        let newItem = itemStore.createItem()
        
        // Determine which section the new item belongs to and reload that section
        let targetSection = newItem.valueInDollars >= 50 ? 0 : 1
        let targetItems = targetSection == 0 ? expensiveItems : inexpensiveItems
        let newIndexPath = IndexPath(row: targetItems.count - 1, section: targetSection)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

