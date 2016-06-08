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
    var currentFocus: Cat?
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.currentFocus = decoder.decodeObjectForKey("currentFocus") as? Cat
    }
    
    convenience init(name: String) {
        self.init()
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let currentFocus = currentFocus { coder.encodeObject(currentFocus, forKey: "currentFocus") }
    }
    
    func addFocus(cat: Cat) {
        
    }
}