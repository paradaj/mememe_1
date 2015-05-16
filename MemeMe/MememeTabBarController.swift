//
//  MememeTabBarController.swift
//  MemeMe
//
//  Created by Mac on 5/1/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit

class MememeTabBarController: UITabBarController{
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let numberOfMemes = appDelegate.memes.count
        let firstTime = appDelegate.firstTime

        // Launch Meme Editor only if this is the initial app launch
        // Credit to OSteve for advising to place this code here in viewDidAppear as placing it somewhere else
        // will generated a warning.
        
        if numberOfMemes == 0 && firstTime {
            
            appDelegate.firstTime = false
            
            let detailController = storyboard?.instantiateViewControllerWithIdentifier("MememeEditor") as! MememeEditorViewController
            
            presentViewController(detailController, animated: true, completion: nil)
            
        }

    }
    
}
