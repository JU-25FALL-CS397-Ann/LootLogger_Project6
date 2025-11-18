//
//  DetailViewController.swift
//  LootLogger_Ch16
//
//  Created by Ann Ubaka on 11/5/25.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - UI Elements
    var nameField: UITextField!
    var serialNumberField: UITextField!
    var valueField: UITextField!
    var dateLabel: UILabel!
    var imageView: UIImageView!
    var cameraButton: UIBarButtonItem!
    var themeToggleButton: UIButton!  // Chapter 16: Theme toggle button
    
    // MARK: - Properties
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bronze Challenge: Add Done button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonPressed(_:))
        )
        
        setupUI()
        
        // Add camera button as left bar button item
        cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture(_:)))
        navigationItem.leftBarButtonItem = cameraButton
        
        // Chapter 16: Add theme toggle button to toolbar
        setupThemeToggleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        // Check if device has camera
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        cameraButton.isEnabled = hasCamera
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save changes back to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
           let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        }
    }
    
    private func setupUI() {
        // Create UI elements programmatically since we're not using storyboard
        view.backgroundColor = .systemBackground
        
        nameField = UITextField()
        serialNumberField = UITextField()
        valueField = UITextField()
        dateLabel = UILabel()
        imageView = UIImageView()
        
        // Configure text fields
        nameField.borderStyle = .roundedRect
        nameField.placeholder = "Item name"
        
        serialNumberField.borderStyle = .roundedRect
        serialNumberField.placeholder = "Serial number"
        
        valueField.borderStyle = .roundedRect
        valueField.placeholder = "Value in dollars"
        valueField.keyboardType = .decimalPad
        
        // Configure labels
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .secondaryLabel
        
        // Configure image view
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        
        // Chapter 16: Create theme toggle button
        themeToggleButton = UIButton(type: .system)
        themeToggleButton.setTitle("Toggle Dark/Light Mode", for: .normal)
        themeToggleButton.addTarget(self, action: #selector(toggleTheme(_:)), for: .touchUpInside)
        themeToggleButton.backgroundColor = .systemBlue
        themeToggleButton.setTitleColor(.white, for: .normal)
        themeToggleButton.layer.cornerRadius = 8
        themeToggleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Add to view with constraints
        [nameField, serialNumberField, valueField, dateLabel, imageView, themeToggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            serialNumberField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            serialNumberField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            serialNumberField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            serialNumberField.heightAnchor.constraint(equalToConstant: 40),
            
            valueField.topAnchor.constraint(equalTo: serialNumberField.bottomAnchor, constant: 16),
            valueField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            valueField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            valueField.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: valueField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Chapter 16: Theme toggle button constraints
            themeToggleButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            themeToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeToggleButton.widthAnchor.constraint(equalToConstant: 250),
            themeToggleButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func updateUI() {
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = "\(item.valueInDollars)"
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Load image from image store
        let imageToDisplay = imageStore.image(forKey: item.itemKey)
        
        if let imageToDisplay = imageToDisplay {
            imageView.image = imageToDisplay
        } else {
            // Placeholder image
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .systemGray3
        }
    }
    
    // Bronze Challenge: Done button action
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        // Dismiss the detail view using popViewController
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Chapter 16: Theme Toggle
    private func setupThemeToggleButton() {
        // Initialize with current theme
        updateThemeButtonTitle()
    }
    
    @objc func toggleTheme(_ sender: UIButton) {
        // Toggle between light, dark, and unspecified (system default)
        switch overrideUserInterfaceStyle {
        case .unspecified:
            overrideUserInterfaceStyle = .dark
        case .light:
            overrideUserInterfaceStyle = .unspecified
        case .dark:
            overrideUserInterfaceStyle = .light
        @unknown default:
            overrideUserInterfaceStyle = .unspecified
        }
        
        updateThemeButtonTitle()
    }
    
    private func updateThemeButtonTitle() {
        let title: String
        switch overrideUserInterfaceStyle {
        case .unspecified:
            title = "Theme: System"
        case .light:
            title = "Theme: Light"
        case .dark:
            title = "Theme: Dark"
        @unknown default:
            title = "Theme: Unknown"
        }
        themeToggleButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Image Picker Actions
    @objc func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Check if camera is available; if not, use photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get picked image from info dictionary
        let image = info[.editedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Update the image view on screen
        imageView.image = image
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
}