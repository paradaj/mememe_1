//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Mac on 5/10/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    var isEditMode = false   // Variable to track edit mode
    
    override func viewDidLoad() {
        
        // Set up edit button on the left side of the nav bar.
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get memes shared array. The reload is necessary to reflect any deletes done on the table controller.
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        memes = appDelegate.memes
        
        collectionView?.reloadData()
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionMemeCell", forIndexPath: indexPath) as! UICollectionViewCell
        let deleteLabel = cell.viewWithTag(120)
        
        // This is my implementation of a delete mode in a collection view controller. If the edit button is tapped
        // then a label with the legend 'Tap to delete' will appear over the cell to indicate that cells can be deleted.
        // It's probably not the most elegant solution but I think it's a good compromise given the approaching deadline :).
        
        if isEditMode {
            
            deleteLabel?.hidden = false
            
        }
        else {
            
            deleteLabel?.hidden = true
            
        }
        
        let meme = memes[indexPath.row]
        
        var collectionImageView = cell.viewWithTag(300) as! UIImageView
        collectionImageView.contentMode = UIViewContentMode.ScaleToFill
        collectionImageView.image = meme.memedImage
                
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // If a cell is selected during edit mode then it gets deleted from the memes shared array and the local array,
        // then the collection controllers is asked to delete the cell. If not in edit mode then
        // detail view controller is presented.
        
        if isEditMode {
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            memes.removeAtIndex(indexPath.row)
            
            let deleteArray = [indexPath]
            
            collectionView.deleteItemsAtIndexPaths(deleteArray)
            
        }
        else {
            
            let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
            detailController.meme = memes[indexPath.row]
            navigationController?.pushViewController(detailController, animated: true)
            
        }
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        // This function gets automatically called when edit button is tapped.
        // If entering edit mode, flag is set to true, meme editor button is disabled 
        // and a reload is called to display the delete label. If leaving edit mode set flag to false
        // and enable editor button.
        
        if editing {
            
            isEditMode = true
            navigationItem.rightBarButtonItem?.enabled = false
            collectionView?.reloadData()
            
        }
        else {
            
            navigationItem.rightBarButtonItem?.enabled = true
            isEditMode = false
            collectionView?.reloadData()
            
        }
        
    }
    
    @IBAction func presentMemeEditor(sender: UIBarButtonItem) {
        
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MememeEditor") as! MememeEditorViewController
        presentViewController(detailController, animated: true, completion: nil)

    }

}
