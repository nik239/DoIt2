//
//  CompletedToDoItemCell.swift
//  DoIt
//
//  Created by Nikita Ivanov on 09/06/2023.
//

import UIKit

final class CompletedToDoItemCell: ToDoItemCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print("New CompletedToDoItemCell was created!")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let attributeString:NSMutableAttributedString = NSMutableAttributedString(string: lblDescription.text ?? "Error loading task description")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        lblDescription.attributedText = attributeString
        
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) isn't implemented")
    }
}
