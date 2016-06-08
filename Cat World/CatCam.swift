//
//  CatCam.swift
//  Cat World
//
//  Created by Willis Allstead on 6/7/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class CatCam: SKCameraNode {
    var currentFocus: NewCat?
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.currentFocus = decoder.decodeObjectForKey("currentFocus") as? NewCat
    }
    
    convenience init(name: String) {
        self.init()
        self.runAction(SKAction.scaleTo(2, duration: 2))
        print("Starting Cat Cam")
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let currentFocus = currentFocus { coder.encodeObject(currentFocus, forKey: "currentFocus") }
    }
}