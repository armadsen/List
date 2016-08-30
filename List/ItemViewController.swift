//
//  ItemViewController.swift
//  List Go 6
//
//  Created by Zebra on 3/4/16.
//  Copyright © 2016 SimpleSumo. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    var faviconURL = ""
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        urlTextField.delegate = self
        
        saveButton.enabled = false
        
        // Jump directly into urlTextField when ItemView loads
        urlTextField.becomeFirstResponder()
    }
    
    // Dismiss keyboard when the view is dismissed
    override func viewWillDisappear(animated: Bool) {
        self.view .endEditing(true)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // If the current field is urlTextField, move to title field
        if textField === urlTextField {
            titleTextField.becomeFirstResponder()
        }
        
        // If the current field is Title, hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Allow save as soon as text is entered
        saveButton.enabled = true
        
        return true
    }
    
    
    // MARK: - Navigation
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(ender: UIBarButtonItem) {
        
        // What happens if there is no text here? Well, the above methods prevent it, I think
        if let title = self.titleTextField.text, url = self.urlTextField.text {
            
            let newItem = Item(title: title, url: url)
            ItemController.sharedController.addItem(newItem)
            self.item = newItem
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}