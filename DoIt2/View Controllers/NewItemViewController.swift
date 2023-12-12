//
//  AddViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 13/05/2023.
//


import UIKit

final class NewItemViewController: UIViewController {
    let currentList: ToDoItemList
    
    init(currentList: ToDoItemList){
        self.currentList = currentList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) isn't implemented")
    }
    
    lazy var fldDescription: UITextField = {
        let fld = UITextField(frame: .zero)
        fld.textAlignment = .left
        fld.textColor = .white
        fld.placeholder = "Task description..."
    
        return fld
    }()
    
    lazy var lblToDo: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = "To Do Item:"
        
        return lbl
    }()
    
    lazy var svDescription: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lblToDo, fldDescription])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        //view.addSubview(stackView)
        
        return stackView
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        //do this setup in View Model
        let btn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        return btn
    }()
    
    @objc func saveButtonTapped() {
        ToDoItem.createWith(taskDescription: fldDescription.text ?? "no description", list: currentList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(svDescription)
        navigationItem.rightBarButtonItem = saveButton
        fldDescription.delegate = self
        setupConstraints()
    }
}

extension NewItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
