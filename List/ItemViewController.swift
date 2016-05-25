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
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field user input through delegate callbacks
        titleTextField.delegate = self
        urlTextField.delegate = self
        
        saveButton.enabled = false
        
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
        
        // Set the Nav title as the title text entered
        navigationItem.title = titleTextField.text
        
        // Get and set the image
        if let urlText = textField.text where textField === urlTextField {
            
            
            saveButton.enabled = true
            /*
            saveButton.enabled = verifyUrl(urlText)
            print("Is save button enabled #1? \(saveButton.enabled)")
            
            if !urlText.isEmpty && verifyUrl(urlText) {
                saveButton.enabled = true
                print("Is save button enabled #2? \(saveButton.enabled)")
            }
            */
            
            print("Beginning to get/set the image")
            
            // Pull the URL and apply filter for favicon
            
            let iconChoice1 = "http://" + urlText + "/apple-touch-icon.png"
            let iconChoice2 = "http://" + urlText + "/favicon-196x196.png"
            let iconChoice3 = "http://" + urlText + "/favicon.ico"
            let iconChoice4 = "http://www.google.com/s2/favicons?domain=" + urlText
            
            if let data = NSData(contentsOfURL: NSURL(string: iconChoice1)!) {
                if UIImage(data: data) != nil {
                    faviconURL = iconChoice1
                    print("\(urlText) used option #1")
                }
            } else if let data = NSData(contentsOfURL: NSURL(string: iconChoice2)!) {
                if UIImage(data: data) != nil {
                    faviconURL = iconChoice2
                    print("\(urlText) used option #2")
                }
            } else if let data = NSData(contentsOfURL: NSURL(string: iconChoice3)!) {
                if UIImage(data: data) != nil {
                    faviconURL = iconChoice3
                    print("\(urlText) used option #3")
                }
            } else if let data = NSData(contentsOfURL: NSURL(string: iconChoice4)!) {
                if UIImage(data: data) != nil {
                    faviconURL = iconChoice4
                    print("\(urlText) used option #4")
                }
            }
            
            /*
            if verifyUrl(iconChoice1) {
                faviconURL = iconChoice1
            } else if verifyUrl(iconChoice2) {
                faviconURL = iconChoice2
            } else {
                faviconURL = iconChoice3
            }
            */
        
            if let checkedURL = NSURL(string: faviconURL) {
                imageImageView.contentMode = .ScaleAspectFit
                downloadImage(checkedURL)
            }
            print("End of code, the image will continue downloading in the background and it will be loaded when it ends.")
        }
    }
    
//    func checkValidItemNames() {
//        // Disable the Save button if the text field
//        let text = titleTextField.text ?? ""
//        saveButton.enabled = !text.isEmpty
//    }
    
    
    // MARK: - Get image for Thumbnail
    
    // Get the data from the url
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    // Download the image
    func downloadImage(url: NSURL) {
        print("Download started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download finished")
                if UIImage(data: data) != nil {
                    self.imageImageView.image = UIImage(data: data)
                } else {
                    self.imageImageView.image = UIImage(named: "blankPage")
                }
            })
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(ender: UIBarButtonItem) {
        
        // What happens if there is no text here? Well, the above methods prevent it, I think
        if let title = self.titleTextField.text, url = self.urlTextField.text, let image = self.imageImageView.image {
            
            let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
            
            let newItem = Item(title: title, url: url, image: imageData)
            ItemController.sharedController.addItem(newItem)
            self.item = newItem
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        /* OLD, Partial method
         
         if let image = self.imageImageView.image {
         let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
         }
         if let title = self.titleTextField.text, url = self.urlTextField.text, image = imageData {
         let newItem = Item(title: title, url: url, image: image)
         ItemController.sharedController.addItem(newItem)
         self.item = newItem
         dismissViewControllerAnimated(true, completion: nil)
         }
         
         */
        
    }
   
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
    
}

