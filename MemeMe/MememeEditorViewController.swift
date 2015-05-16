//
//  MememeEditorViewController.swift
//  MemeMe
//
//  Created by Mac on 4/30/15.
//  Copyright (c) 2015 att. All rights reserved.
//
//  URL below was referenced to crop the nav and tool bar from the meme
//
//  http://stackoverflow.com/questions/12687909/ios-screenshot-part-of-the-screen
//

import UIKit

class MememeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var activeTextField: UITextField! // Variable to keep track of the active text field
    var newMeme: Meme!
    var memeToEdit: Meme!             // Meme from the detail view in case editor called from there.
    var newMemedImage: UIImage!
    var isMemeEdit = false            // Variable that determines if the editor was called from the detail view.

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0
    ]

    override func viewDidLoad() {
        
        // Text fields set-up. Text fields and share button are disabled until an image is selected.
        
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.borderStyle = UITextBorderStyle.None
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        topTextField.enabled = false
        bottomTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.delegate = self
        bottomTextField.enabled = false
        shareButton.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Subscribe to notifications and enable camera button if present in the device.
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // If the editor was called from the detail view all fields are populated with the passed meme
        // Text fields and share button are enabled as well.
        
        if isMemeEdit {
            
            topTextField.text = memeToEdit.topText
            bottomTextField.text = memeToEdit.bottomText
            imagePickerView.image = memeToEdit.origImage
            topTextField.enabled = true
            bottomTextField.enabled = true
            shareButton.enabled = true

        }
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // Move view only if the bottom text field (tag = 20) is being activated
        
        if activeTextField.tag == 20 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Move view only if the bottom text field (tag = 20) is being activated

        if activeTextField.tag == 20 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Keep track of the active text field. Clear the existing text only if it is the placeholder text
        // as we don't want to clear user entered text.
        
        activeTextField = textField
        
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // if user is leaving field and no text was entered, placeholder text is repopulated, otherwise text field
        // is very difficult to see in case user returns later.
        
        if !textField.hasText() {
            if textField.tag == 10 {
                textField.text = "TOP"
            }
            else{
                textField.text = "BOTTOM"
            }
        }
        textField.resignFirstResponder()
        return true
        
    }
    

    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // After an image was selected enable text fields and share button
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            topTextField.enabled = true
            bottomTextField.enabled = true
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Calculate the Y position (X position will always be zero) and size of the meme
        // considering we want to crop the nav and tool bars.
        
        let memeY = 0 - view.frame.origin.y - topNavBar.frame.height - UIApplication.sharedApplication().statusBarFrame.height
        let memeHeight = view.frame.height - bottomToolBar.frame.height - topNavBar.frame.height - UIApplication.sharedApplication().statusBarFrame.height
        let memeSize = CGSize(width: view.frame.width, height: memeHeight)

  
        // Obtain first an image of the whole screen
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let auxImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Then set image context the size of the meme and draw the full image at the new Y 'cropping' position
        
        UIGraphicsBeginImageContext(memeSize)
        auxImage.drawAtPoint(CGPointMake(view.frame.origin.x, memeY))
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
        
    }
    
    func completeShareMeme(){
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        // If the meme to save comes from an existing meme then a replace is done in the memes array.
        // If it is a brand new meme then an add is done in the memes array
        
        if isMemeEdit {
            
            let auxMemesArray = appDelegate.memes as NSArray // Cast to NSArray so that the indexOfObject method can be used
            let memeIndex = auxMemesArray.indexOfObject(memeToEdit)
            
            if memeIndex != NSNotFound {
                
                newMeme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, origImage: memeToEdit.memedImage, memedImage: newMemedImage)
                appDelegate.memes[memeIndex] = newMeme
                
            }
            
        }
        else {
        
            newMeme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, origImage: imagePickerView.image!, memedImage: newMemedImage)
            appDelegate.memes.append(newMeme)
            
        }
        
        let mainTabController = storyboard?.instantiateViewControllerWithIdentifier("MemesTabBarController") as! MememeTabBarController
        presentViewController(mainTabController, animated: true, completion: nil)

        
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // Generate meme
        
        newMemedImage = generateMemedImage()

        // Instantiate the activity controller with a closure that will call the completeShareMeme function
        
        typealias UIActivityViewControllerCompletionWithItemsHandler = (String!, Bool, [AnyObject]!, NSError!) -> Void
        
        let controller = UIActivityViewController(activityItems: [newMemedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (s, ok, items, err) -> Void in
            
            if ok {
                
                self.completeShareMeme()
                
            }
        }
        
        presentViewController(controller, animated: true, completion: nil)
        
    }

    @IBAction func backToTab(sender: UIBarButtonItem) {
        
        let mainTabController = storyboard?.instantiateViewControllerWithIdentifier("MemesTabBarController") as! MememeTabBarController
        
        presentViewController(mainTabController, animated: true, completion: nil)

    }
    
}