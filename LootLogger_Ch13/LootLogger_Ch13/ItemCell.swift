//
//  ItemCell.swift
//  LootLogger_Ch12
//
//  Created by Ann Ubaka on 11/5/25.
//

import UIKit

class ItemCell: UITableViewCell {
    var nameLabel: UILabel!
    var serialNumberLabel: UILabel!
    var valueLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        nameLabel = UILabel()
        serialNumberLabel = UILabel()
        valueLabel = UILabel()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        serialNumberLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        serialNumberLabel.textColor = .secondaryLabel
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        serialNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(serialNumberLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
            
            serialNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            serialNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            serialNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            serialNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Add disclosure indicator for navigation
        accessoryType = .disclosureIndicator
    }
    
    func configure(for item: Item) {
        nameLabel.text = item.name
        serialNumberLabel.text = item.serialNumber
        valueLabel.text = "$\(item.valueInDollars)"
        
        // Bronze Challenge: Cell Colors
        // Green if valueInDollars < 50, Red if valueInDollars >= 50
        if item.valueInDollars < 50 {
            valueLabel.textColor = .systemGreen
        } else {
            valueLabel.textColor = .systemRed
        }
    }
}