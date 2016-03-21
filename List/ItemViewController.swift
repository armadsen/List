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
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field user input through delegate callbacks
        titleTextField.delegate = self
        urlTextField.delegate = self
        
        checkValidItemNames()
        
        // Jump directly into titleTextField when ItemView loads
        titleTextField.becomeFirstResponder()
    }
    
    // Dismiss keyboard at the same time as the view is dismissed
    override func viewWillDisappear(animated: Bool) {
        self.view .endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable save button while editing
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidItemNames()
        // Set the Nav title as the title text entered
        navigationItem.title = titleTextField.text
    }
    
    func checkValidItemNames() {
        // Disable the Save button if either the text field or url is empty.
        let text = titleTextField.text ?? ""
        let url = urlTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
        saveButton.enabled = !url.isEmpty

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
        }
    
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

