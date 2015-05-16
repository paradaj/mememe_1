//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mac on 5/11/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up delete and edit buttons on the right side of the nav bar.
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme:")
        let editButton   = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme:")
        let buttonsArray = [deleteButton, editButton]
        
        navigationItem.rightBarButtonItems = buttonsArray
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        memeDetailImageView.contentMode = UIViewContentMode.ScaleAspectFit
        memeDetailImageView.image = meme.memedImage
        
        var barItemsArray = tabBarController?.tabBar.items
        
        // Disappear the tab bar because a user tapping one of the tab bar items will wreak havoc on the navigation
        
        tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Tab bar reappears.
        
        tabBarController?.tabBar.hidden = false
        
    }
    
    func deleteMeme(sender: UIBarButtonItem) {

        // If delete button tapped, delete meme and return to sent memes controller
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate

        let auxArray = appDelegate.memes as NSArray
        let auxIndex = auxArray.indexOfObject(meme)
        
        appDelegate.memes.removeAtIndex(auxIndex)
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func editMeme(sender: UIBarButtonItem) {
        
        // if Edit button tapped pass meme, set edit flag to true and present meme editor.
        
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MememeEditor") as! MememeEditorViewController
        detailController.isMemeEdit = true
        detailController.memeToEdit = meme
        presentViewController(detailController, animated: true, completion: nil)

    }
    
}
