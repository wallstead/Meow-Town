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
        action?()
    }
}

//class SKPixelButtonNode: SKPixelSpriteNode {
//    var defaultTexture: SKTexture
//    var activeTexture: SKTexture
//    var downSound: SKAudioNode
//    var upSound: SKAudioNode
//    var text: SKLabelNode?
//
//    init(textureName: String, text: String?) {
//        let activeButtonImage = buttonImage+"_pressed"
//        defaultButton = SKTexture(imageNamed: buttonImage)
//        defaultButton.filteringMode = SKTextureFilteringMode.Nearest
//        activeButton = SKTexture(imageNamed: activeButtonImage)
//        activeButton.filteringMode = SKTextureFilteringMode.Nearest
//        buttonDown = SKAudioNode(fileNamed: "button_down.wav")
//        buttonDown.autoplayLooped = false
//        buttonDown.positional = false
//        buttonUp = SKAudioNode(fileNamed: "button_up.wav")
//        buttonUp.autoplayLooped = false
//        buttonUp.positional = false
//        action = buttonAction
//
//
//        super.init(textureName: buttonImage, pressAction: {})
//
//        userInteractionEnabled = true
//        self.addChild(buttonDown)
//        self.addChild(buttonUp)
//        if (buttonText != nil) {
//            text = SKLabelNode(fontNamed: "Silkscreen")
//
//            text!.text = buttonText
//            text!.setScale(1/10)
//            text!.fontSize = 80
//            text!.fontColor = SKColor.whiteColor()
//            text!.verticalAlignmentMode = .Center
//            text!.zPosition = 1
//            self.addChild(text!)
//
//        }
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.texture = activeButton
//        buttonDown.runAction(SKAction.play())
//        if (text != nil) {
//            text?.position.y = -1
//        }
//    }
//
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let location: CGPoint = touch.locationInNode(self.parent!)
//            if self.containsPoint(location) {
//                self.texture = activeButton
//                if (text != nil) {
//                    text?.position.y = -1
//                }
//            } else {
//                self.texture = defaultButton
//                if (text != nil) {
//                    text?.position.y = 0
//                }
//            }
//        }
//
//    }
//
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        if self.texture == activeButton {
//            action()
//            buttonUp.runAction(SKAction.play())
//        }
//
//        if (text != nil) {
//            text?.position.y = 0
//        }
//        self.texture = defaultButton
//
//    }
//}

//class SKPixelSpriteNode: SKSpriteNode {
//    var textureName: String
//    internal var pressAction: () -> Void

//    init(textureName: String, pressAction: () -> Void) {
//        let texture = SKTexture(imageNamed: textureName)
//        self.textureName = textureName
//        texture.filteringMode = SKTextureFilteringMode.Nearest
//        self.pressAction = pressAction
//        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
//    }
//    
//    func changeTextureTo(textureName: String) {
//        self.size = CGSizeZero
//        let newTexture = SKTexture(imageNamed: textureName)
//        newTexture.filteringMode = SKTextureFilteringMode.Nearest
//        
//        self.texture = newTexture
//        let oldXScale = xScale
//        let oldYScale = yScale
//        setScale(1)
//        size.height = newTexture.size().height
//        size.width = newTexture.size().width
//        xScale = oldXScale
//        yScale = oldYScale
//        
//        print("size: \(self.size), newTexture size: \(newTexture.size())")
//    }
//    
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        pressAction()
//    }
//    
//
//    
//    required convenience init(coder decoder: NSCoder) {
//        super.init()
//        self.wallpaper = decoder.decodeObjectForKey("wallpaper") as! SKPixelSpriteNode
//        self.cats = decoder.decodeObjectForKey("cats") as! [NewCat]
//        
//        layout()
//    }
//    
//    convenience init(name: String) {
//        self.init()
//        self.wallpaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
//        self.cats = []
//        
//        layout()
//    }
//    
//    override func encodeWithCoder(coder: NSCoder) {
//        if let wallpaper = wallpaper { coder.encodeObject(wallpaper, forKey: "wallpaper") }
//        if let cats = cats { coder.encodeObject(cats, forKey: "cats") }
//    }
//
//}
//
//
//
//class SKPixelMenuButtonNode: SKPixelSpriteNode {
//    var defaultButton: SKTexture
//    var activeButton: SKTexture
//    var buttonUI: SKPixelSpriteNode
//    var buttonDown: SKAudioNode
//    var buttonUp: SKAudioNode
//    var text: SKLabelNode?
//    internal var action: () -> Void
//    
//    
//    
//    init(buttonIcon: String, UIType: String, buttonText: String?, buttonAction: () -> Void) {
//        defaultButton = SKTexture(imageNamed: "topbar_menupanel_itemcategory")
//        defaultButton.filteringMode = SKTextureFilteringMode.Nearest
//        activeButton = SKTexture(imageNamed: "topbar_menupanel_itemcategory_pressed")
//        activeButton.filteringMode = SKTextureFilteringMode.Nearest
//        buttonDown = SKAudioNode(fileNamed: "button_down.wav")
//        buttonDown.autoplayLooped = false
//        buttonDown.positional = false
//        buttonUp = SKAudioNode(fileNamed: "button_up.wav")
//        buttonUp.autoplayLooped = false
//        buttonUp.positional = false
//        if UIType == "category" {
//            buttonUI = SKPixelSpriteNode(textureName: "topbar_menupanel_itemcategory_ui", pressAction: {})
//        } else {
//            buttonUI = SKPixelSpriteNode(textureName: "topbar_menupanel_itemcategory_ui", pressAction: {})
//        }
//        action = buttonAction
//        
//        
//        super.init(textureName: "topbar_menupanel_itemcategory", pressAction: {})
//        
//        userInteractionEnabled = true
//        self.addChild(buttonDown)
//        self.addChild(buttonUp)
//        self.addChild(buttonUI)
//        buttonUI.zPosition = 1
//        
//        if (buttonText != nil) {
//            text = SKLabelNode(fontNamed: "Silkscreen")
//            
//            text!.text = buttonText
//            text!.setScale(1/10)
//            text!.fontSize = 80
//            text!.fontColor = SKColor.whiteColor()
//            text!.verticalAlignmentMode = .Center
//            text!.zPosition = 2
//            self.addChild(text!)
//            
//        }
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.texture = activeButton
//        buttonDown.runAction(SKAction.play())
//        if (text != nil) {
//            text?.position.y = -1
//            buttonUI.position.y = -1
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let location: CGPoint = touch.locationInNode(self.parent!)
//            if self.containsPoint(location) {
//                self.texture = activeButton
//                if (text != nil) {
//                    text?.position.y = -1
//                    buttonUI.position.y = -1
//                }
//            } else {
//                self.texture = defaultButton
//                if (text != nil) {
//                    text?.position.y = 0
//                    buttonUI.position.y = 0
//                }
//            }
//        }
//        
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        if self.texture == activeButton {
//            action()
//            buttonUp.runAction(SKAction.play())
//        }
//        
//        if (text != nil) {
//            text?.position.y = 0
//            buttonUI.position.y = 0
//        }
//        self.texture = defaultButton
//        
//    }
//}


