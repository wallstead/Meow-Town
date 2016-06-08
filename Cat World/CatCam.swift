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
    var focusing: Bool!
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.currentFocus = decoder.decodeObjectForKey("currentFocus") as? Cat
        self.focusing = false
    }
    
    convenience init(name: String) {
        self.init()
        self.focusing = false
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let currentFocus = currentFocus { coder.encodeObject(currentFocus, forKey: "currentFocus") }
    }
    
    func addFocus(cat: Cat) {
        print("attempting to focus on \(cat.firstname)")
        if !focusing {
            print("not focusing yet")
            currentFocus = cat
        }
    }
    
    func update(currentTime: CFTimeInterval) {
        if currentFocus != nil {
            self.position = currentFocus!.sprite.position
        }
    }
}