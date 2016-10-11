//
//  ItemViewController.swift
//  List Go 6
//
//  Created by Zebra on 3/4/16.
//  Copyright © 2016 SimpleSumo. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        urlTextField.delegate = self
        
        saveButton.isEnabled = false
        
        // Jump directly into urlTextField when ItemView loads
        urlTextField.becomeFirstResponder()
    }
    
    // Dismiss keyboard when the view is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        self.view .endEditing(true)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // If urlTextField is current field and "return" button is tapped, move to title field
        if textField === urlTextField {
            titleTextField.becomeFirstResponder()
        }
        
        // If titleTextField is current field and "return" button is tapped, hide keyboard
        if textField === titleTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow Save as soon as text changed
        saveButton.isEnabled = true
        
        return true
    }
    
    
    // MARK: - Navigation
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ ender: UIBarButtonItem) {
        
        if let title = self.titleTextField.text, let url = self.urlTextField.text {
            
            let newItem = Item(title: title, url: url)
            ItemController.sharedController.addItem(newItem)
            self.item = newItem
            dismiss(animated: true, completion: nil)
        }
    }
    
}
