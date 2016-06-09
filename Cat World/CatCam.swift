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
    
    func toggleFocus(cat: Cat) {
        if currentFocus == cat { // unfocus
            if !focusing {
                currentFocus = nil
                unfocus()
            }
        } else { // focus
            if !focusing {
                let zoom = SKAction.scaleTo(0.75, duration: 0.5)
                zoom.timingMode = .EaseOut
                self.runAction(zoom)
                currentFocus = cat
            }
        }
        
    }
    
    func unfocus() {
        self.removeAllActions()
        let resetPosition = SKAction.moveTo(GameScene.current.frame.mid(), duration: 0.5)
        resetPosition.timingMode = .EaseOut
        self.runAction(resetPosition)
        let zoom = SKAction.scaleTo(1, duration: 0.5)
        zoom.timingMode = .EaseOut
        self.runAction(zoom)
    }
    
    func update(currentTime: CFTimeInterval) {
        if currentFocus != nil {
            var point = currentFocus!.sprite.positionInScene
            if currentFocus!.isKitten() {
                point.y += 40
            } else {
                point.y += 70
            }
            let action = SKAction.moveTo(point, duration: 0.25)
            self.runAction(action)
        }
    }
}