//
//  SKPixelSpriteNode.swift
//  Cat World
//
//  Created by Willis Allstead on 4/13/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class SKPixelSpriteNode: SKSpriteNode {
    var textureName: String
    internal var action: (() -> Void)?
    
    init(textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        self.textureName = textureName
        texture.filteringMode = SKTextureFilteringMode.Nearest
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.textureName = aDecoder.decodeObjectForKey("texturename") as! String
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.textureName, forKey: "texturename")
        super.encodeWithCoder(aCoder)
    }
    
    func changeTextureTo(textureName: String) {
        self.size = CGSizeZero
        let newTexture = SKTexture(imageNamed: textureName)
        newTexture.filteringMode = .Nearest
        self.texture = newTexture
        let oldXScale = xScale
        let oldYScale = yScale
        setScale(1)
        size.height = newTexture.size().height
        size.width = newTexture.size().width
        xScale = oldXScale
        yScale = oldYScale
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        action?()
    }
}

class SKPixelButtonNode: SKPixelSpriteNode {
    var defaultTexture: SKTexture
    var activeTexture: SKTexture
    var downSound: SKAudioNode
    var upSound: SKAudioNode
    var text: SKLabelNode?
    
    init(textureName: String, text: String? = nil) {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = SKTextureFilteringMode.Nearest
        let texturePressed = SKTexture(imageNamed: textureName+"_pressed")
        texturePressed.filteringMode = SKTextureFilteringMode.Nearest
        self.defaultTexture = texture
        self.activeTexture = texturePressed
        self.downSound = SKAudioNode(fileNamed: "button_down.wav")
        self.upSound = SKAudioNode(fileNamed: "button_up.wav")
        super.init(textureName: textureName)
        if (text != nil) {
            self.text = SKLabelNode(fontNamed: "Silkscreen")
            self.text!.text = text
            self.text!.setScale(1/10)
            self.text!.fontSize = 80
            self.text!.fontColor = SKColor.whiteColor()
            self.text!.verticalAlignmentMode = .Center
            self.text!.zPosition = 1
            self.addChild(self.text!)
        }
        self.textureName = textureName
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.defaultTexture = aDecoder.decodeObjectForKey("defaulttexture") as! SKTexture
        self.activeTexture = aDecoder.decodeObjectForKey("activeTexture") as! SKTexture
        self.downSound = aDecoder.decodeObjectForKey("downSound") as! SKAudioNode
        self.upSound = aDecoder.decodeObjectForKey("upSound") as! SKAudioNode
        self.text = aDecoder.decodeObjectForKey("text") as? SKLabelNode
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.defaultTexture, forKey: "defaultTexture")
        aCoder.encodeObject(self.activeTexture, forKey: "activeTexture")
        aCoder.encodeObject(self.downSound, forKey: "downSound")
        aCoder.encodeObject(self.upSound, forKey: "upSound")
        aCoder.encodeObject(self.text, forKey: "text")
        super.encodeWithCoder(aCoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = activeTexture
        downSound.runAction(SKAction.play())
        if (text != nil) {
            text?.position.y = -1
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.locationInNode(self.parent!)
            if self.containsPoint(location) {
                self.texture = activeTexture
                if (text != nil) {
                    text?.position.y = -1
                }
            } else {
                self.texture = defaultTexture
                if (text != nil) {
                    text?.position.y = 0
                }
            }
        }

    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.texture == activeTexture {
            action?()
            upSound.runAction(SKAction.play())
        }
        if (text != nil) {
            text?.position.y = 0
        }
        self.texture = defaultTexture
    }
}

class SKPixelToggleButtonNode: SKPixelButtonNode {
    var enabled: Bool!
    
    override init(textureName: String, text: String? = nil) {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = SKTextureFilteringMode.Nearest
        let texturePressed = SKTexture(imageNamed: textureName+"_pressed")
        texturePressed.filteringMode = SKTextureFilteringMode.Nearest
        super.init(textureName: textureName, text: text)
        self.enabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.enabled = aDecoder.decodeObjectForKey("enabled") as! Bool
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.enabled, forKey: "enabled")
        super.encodeWithCoder(aCoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = activeTexture
        downSound.runAction(SKAction.play())
        if (text != nil) {
            text?.position.y = -1
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.locationInNode(self.parent!)
            if self.containsPoint(location) {
                self.texture = activeTexture
                if (text != nil) {
                    text?.position.y = -1
                }
            } else {
                self.texture = defaultTexture
                if (text != nil) {
                    text?.position.y = 0
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !enabled { // enable
            if self.texture == activeTexture {
                action?()
                upSound.runAction(SKAction.play())
                if (text != nil) {
                    text?.position.y = -1
                }
                enabled = true
            }
        } else { // disable
            if self.texture == activeTexture {
                upSound.runAction(SKAction.play())
                if (text != nil) {
                    text?.position.y = 0
                }
                self.texture = defaultTexture
                enabled = false
            }
        }
        
    }
}

class SKPixelCatNode: SKPixelSpriteNode {
    var skinName: String
    
    init(catName: String) {
        self.skinName = catName
        super.init(textureName: self.skinName)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.skinName = aDecoder.decodeObjectForKey("catname") as! String
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.skinName, forKey: "catname")
        super.encodeWithCoder(aCoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {}
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.locationInNode(self.parent!)
            if self.containsPoint(location) {
                action?()
            }
        }
    }
    
    func liftLegs() {
        self.changeTextureTo(skinName+"_floating")
    }
    
    func stand() {
        self.changeTextureTo(skinName)
    }
    
    func closeEyes() {
        self.changeTextureTo(skinName+"_blinking")
    }
    
    func openEyes() {
        stand()
    }
    
    func pube() {
        let grownCatName = textureName.stringByReplacingOccurrencesOfString("_kitten", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.skinName = grownCatName
        stand()
        print("pubed")
    }
}