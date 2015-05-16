//
//  Meme.swift
//  MemeMe
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 att. All rights reserved.
//
//  Meme class definition including an initialiser
//

import UIKit

class Meme {
    
    var topText: String
    var bottomText: String
    var origImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, origImage: UIImage, memedImage: UIImage){
        
        self.topText = topText
        self.bottomText = bottomText
        self.origImage = origImage
        self.memedImage = memedImage
        
    }
    
}