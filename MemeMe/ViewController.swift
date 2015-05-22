//
//  ViewController.swift
//  MemeMe
//
//  Created by User on 5/17/15.
//  Copyright (c) 2015 Neural Health Systems. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Instantiate image picker, connect/declare outlets
    
    let imagePicker = UIImagePickerController()
    var newMedia: Bool?
    

    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editorNavigation: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var sourceToolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    // Set text field attributes and disable share and cancel buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 34)!,
            NSStrokeWidthAttributeName : -3.0]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        shareButton.enabled = false
        cancelButton.enabled = false
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Disable cameraButton if no camera available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe notifications
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe notifications
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeFromKeyboardWillHideNotifications()
    }

   // Enable picking from a photo library
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        newMedia = false
        
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    // Enable picking from camera roll
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        newMedia = true
        
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    // Enable sharing with activity view controller
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        var sharedMeme = generateImage()
        let activityViewController = UIActivityViewController(activityItems: [sharedMeme], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    // Save the meme with save meme method
        activityViewController.completionWithItemsHandler = {(activity, success, items, error) in
            self.saveMemeObject()
            self.dismissViewControllerAnimated(true , completion: nil)
            self.shareButton.enabled = false
            self.cancelButton.enabled = false
        }
    }
    
    // On cancel selection revert to initiating parent view
    
    @IBAction func cancelEditor(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true , completion: nil)
        
    }
 
    // Keyboard subscribe and unsubscribe notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // When the keyboardWillShow notification is received shift the view's frame up a distance equal to the keyboard height
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue  // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // When keyboardWillHide notification is received shift the view's frame back down a distance equal to the keyboard height
    func keyboardWillHide(notification: NSNotification){
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += setKeyboardHeight(notification)
        }
    }
    
    func setKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Delegate methods image picker controller
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageSelected.image = image

        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    // Delegate methods textField
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.placeholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // Generate memed image method
    
    func generateImage() -> UIImage {
        
        editorNavigation.hidden = true
        sourceToolbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        sourceToolbar.hidden = false
        editorNavigation.hidden = false
        
        return memedImage
    }
    
    // Save the meme object method
    
    func saveMemeObject() {
        
        // Create the meme
        
        var meme = Meme(textTop: topText.text!, textBottom: bottomText.text!, picture: imageSelected.image!, memedImage: generateImage())
        
        // Add meme to array in appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        
    }

    
}