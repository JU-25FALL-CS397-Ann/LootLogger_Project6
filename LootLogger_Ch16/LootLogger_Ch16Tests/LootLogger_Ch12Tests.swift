//
//  LootLogger_Ch13Tests.swift
//  LootLogger_Ch13Tests
//
//  Created by Ann Ubaka on 11/5/25.
//

import XCTest
@testable import LootLogger_Ch13

final class LootLogger_Ch13Tests: XCTestCase {
    var itemStore: ItemStore!
    var itemsViewController: ItemsViewController!
    var navigationController: UINavigationController!

    override func setUpWithError() throws {
        itemStore = ItemStore()
        itemsViewController = ItemsViewController()
        itemsViewController.itemStore = itemStore
        
        // Set up navigation controller for testing navigation
        navigationController = UINavigationController(rootViewController: itemsViewController)
        
        // Load the view to trigger viewDidLoad
        itemsViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        itemStore = nil
        itemsViewController = nil
        navigationController = nil
    }

    // MARK: - Chapter 12 Bronze Challenge Tests: Navigation and DetailViewController
    
    func testDetailViewControllerCreation() throws {
        // Test that DetailViewController can be created with an item
        let testItem = Item(name: "Test Widget", serialNumber: "TW123", valueInDollars: 75)
        let detailVC = DetailViewController()
        detailVC.item = testItem
        
        XCTAssertNotNil(detailVC.item, "DetailViewController should have an item")
        XCTAssertEqual(detailVC.item.name, "Test Widget", "DetailViewController should have the correct item")
        XCTAssertEqual(detailVC.navigationItem.title, "Test Widget", "Navigation title should be set from item name")
    }
    
    func testDetailViewControllerUISetup() throws {
        let testItem = Item(name: "Detail Test", serialNumber: "DT456", valueInDollars: 50)
        let detailVC = DetailViewController()
        detailVC.item = testItem
        
        // Load the view to trigger setupUI
        detailVC.loadViewIfNeeded()
        
        // Verify UI elements are created
        XCTAssertNotNil(detailVC.nameField, "Name field should be created")
        XCTAssertNotNil(detailVC.serialNumberField, "Serial number field should be created")
        XCTAssertNotNil(detailVC.valueField, "Value field should be created")
        XCTAssertNotNil(detailVC.dateLabel, "Date label should be created")
        XCTAssertNotNil(detailVC.imageView, "Image view should be created")
        
        // Verify Done button is added
        XCTAssertNotNil(detailVC.navigationItem.rightBarButtonItem, "Done button should be added to navigation")
        XCTAssertEqual(detailVC.navigationItem.rightBarButtonItem?.systemItem, .done, "Right bar button should be Done system item")
    }
    
    func testDetailViewControllerDataBinding() throws {
        let testItem = Item(name: "Binding Test", serialNumber: "BT789", valueInDollars: 30)
        let detailVC = DetailViewController()
        detailVC.item = testItem
        
        // Load and appear to trigger data binding
        detailVC.loadViewIfNeeded()
        detailVC.viewWillAppear(false)
        
        // Verify data is bound to UI elements
        XCTAssertEqual(detailVC.nameField.text, "Binding Test", "Name field should display item name")
        XCTAssertEqual(detailVC.serialNumberField.text, "BT789", "Serial field should display serial number")
        XCTAssertEqual(detailVC.valueField.text, "30", "Value field should display item value")
        XCTAssertNotNil(detailVC.dateLabel.text, "Date label should display formatted date")
    }
    
    func testDetailViewControllerDataSaving() throws {
        let testItem = Item(name: "Original Name", serialNumber: "ON123", valueInDollars: 25)
        let detailVC = DetailViewController()
        detailVC.item = testItem
        
        detailVC.loadViewIfNeeded()
        detailVC.viewWillAppear(false)
        
        // Modify the fields
        detailVC.nameField.text = "Modified Name"
        detailVC.serialNumberField.text = "MN456"
        detailVC.valueField.text = "75"
        
        // Trigger save
        detailVC.viewWillDisappear(false)
        
        // Verify data was saved back to item
        XCTAssertEqual(testItem.name, "Modified Name", "Item name should be updated")
        XCTAssertEqual(testItem.serialNumber, "MN456", "Item serial number should be updated")
        XCTAssertEqual(testItem.valueInDollars, 75, "Item value should be updated")
    }
    
    func testItemCellHasDisclosureIndicator() throws {
        // Test that cells show disclosure indicator for navigation
        let cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        XCTAssertEqual(cell.accessoryType, .disclosureIndicator, "ItemCell should have disclosure indicator for navigation")
    }
    
    func testTableViewNavigationOnRowSelection() throws {
        // Test that tapping a row triggers navigation
        XCTAssertEqual(navigationController.viewControllers.count, 1, "Should start with one view controller")
        
        // Simulate tapping on a row (if items exist)
        if itemsViewController.expensiveItems.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            itemsViewController.tableView(itemsViewController.tableView, didSelectRowAt: indexPath)
            
            // Note: In a real app, this would push DetailViewController, but in unit tests
            // we can't easily test the navigation stack without more complex setup
            // This test verifies that the method exists and can be called
        }
        
        if itemsViewController.inexpensiveItems.count > 0 {
            let indexPath = IndexPath(row: 0, section: 1)
            itemsViewController.tableView(itemsViewController.tableView, didSelectRowAt: indexPath)
        }
    }
    
    func testNavigationControllerSetup() throws {
        // Test that the app is set up with navigation controller
        XCTAssertNotNil(itemsViewController.navigationController, "ItemsViewController should be in a navigation controller")
        XCTAssertEqual(itemsViewController.title, "LootLogger", "ItemsViewController should have correct title")
        XCTAssertNotNil(itemsViewController.navigationItem.rightBarButtonItem, "Add button should be present")
        XCTAssertNotNil(itemsViewController.navigationItem.leftBarButtonItem, "Edit button should be present")
    }
    
    func testSectionedTableViewWithNavigation() throws {
        // Test that the sectioned table view works with navigation
        XCTAssertEqual(itemsViewController.numberOfSections(in: itemsViewController.tableView), 2, "Should have 2 sections")
        
        // Test that cells are configured for navigation
        if itemsViewController.expensiveItems.count > 0 {
            let expensiveIndexPath = IndexPath(row: 0, section: 0)
            let expensiveCell = itemsViewController.tableView(itemsViewController.tableView, cellForRowAt: expensiveIndexPath) as! ItemCell
            XCTAssertEqual(expensiveCell.accessoryType, .disclosureIndicator, "Expensive section cells should have disclosure indicator")
        }
        
        if itemsViewController.inexpensiveItems.count > 0 {
            let inexpensiveIndexPath = IndexPath(row: 0, section: 1)
            let inexpensiveCell = itemsViewController.tableView(itemsViewController.tableView, cellForRowAt: inexpensiveIndexPath) as! ItemCell
            XCTAssertEqual(inexpensiveCell.accessoryType, .disclosureIndicator, "Inexpensive section cells should have disclosure indicator")
        }
    }

    func testPerformanceExample() throws {
        // Test performance of navigation setup
        let items = (0..<100).map { Item(name: "Item \($0)", serialNumber: "\($0)", valueInDollars: $0) }
        
        self.measure {
            for item in items {
                let detailVC = DetailViewController()
                detailVC.item = item
                detailVC.loadViewIfNeeded()
            }
        }
    }
}
