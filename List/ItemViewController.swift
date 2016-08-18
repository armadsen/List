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
        
        // Jump directly into titleTextField when ItemView loads
        urlTextField.becomeFirstResponder()
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
        
        checkValidTitle()
        
        // Get and set the image
        if let urlText = textField.text where textField === urlTextField {
            
            // saveButton.enabled = verifyUrl(urlText)
            
            checkValidUrl()
    }
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


// MARK: - Data validation

// Disable the Save button if the text field is empty
func checkValidTitle() {
    let text = titleTextField.text ?? ""
    saveButton.enabled = !text.isEmpty
    if text.isEmpty {
        messageTextLabel.text = "Please enter a title"
    } else {
        // Set the Nav title as the title text entered
        navigationItem.title = titleTextField.text
        messageTextLabel.text = ""
    }
}

// Disable the Save button if the url field is empty
func checkValidUrl() {
    let text = urlTextField.text ?? ""
    saveButton.enabled = !text.isEmpty
    if text.isEmpty {
        messageTextLabel.text = "Please enter a url"
    } else {
        messageTextLabel.text = ""
    }
}

/*
 // Verify the Url
 func verifyUrl (urlString: String?) -> Bool {
 // Check for nil
 if let urlString = urlString {
 // Create NSURL
 if let url = NSURL(string: urlString) {
 // Check if can open the NSURL
 if UIApplication.sharedApplication().canOpenURL(url) == true {
 messageTextLabel.text = ""
 return true
 } else {
 messageTextLabel.text = "Please enter a valid URL"
 return false
 }
 }
 }
 return false
 }
 */

}