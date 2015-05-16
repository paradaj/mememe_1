//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Mac on 5/9/15.
//  Copyright (c) 2015 att. All rights reserved.
//
// Implementing edit mode is much easier on table view controllers as Apple provides all the functionality out of the box.
//

import UIKit

class MemesTableViewController: UITableViewController, UITableViewDataSource {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        
        // Set up edit button on the left side of nav bar.
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get memes shared array. The reload is necessary to reflect any deletes done on the collection controller.
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate

        memes = appDelegate.memes
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeCell
        let meme = memes[indexPath.row]
        
        cell.customImageView.image = meme.memedImage
        cell.customLabel.text = meme.topText + meme.bottomText 
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        // When entering edit mode disable editor button, when leaving enable it.
        
        if editing {
            
            navigationItem.rightBarButtonItem?.enabled = false
            
        }
        else {
            
            navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // If is to be deleted, delete it from the memes shared array, the local memes array
        // and ask the table to animate the deletion
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            memes.removeAtIndex(indexPath.row)
            let delteArray = [indexPath]
            tableView.deleteRowsAtIndexPaths(delteArray, withRowAnimation: UITableViewRowAnimation.Fade)

        }
    }
    
    @IBAction func presentMemeEditor(sender: UIBarButtonItem) {
        
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MememeEditor") as! MememeEditorViewController
        presentViewController(detailController, animated: true, completion: nil)


    }
}
