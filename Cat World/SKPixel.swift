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
        texture.filteringMode = .nearest
        super.init(texture: texture, color: UIColor.clear(), size: texture.size())
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.textureName = aDecoder.decodeObject(forKey: "texturename") as! String
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.textureName, forKey: "texturename")
        super.encode(with: aCoder)
    }
    
    func changeTextureTo(textureName: String) {
        self.size = CGSize(width: 0, height: 0)
        let newTexture = SKTexture(imageNamed: textureName)
        newTexture.filteringMode = .nearest
        self.texture = newTexture
        let oldXScale = xScale
        let oldYScale = yScale
        setScale(1)
        size.height = newTexture.size().height
        size.width = newTexture.size().width
        xScale = oldXScale
        yScale = oldYScale
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?()
    }
}

class SKPixelButtonNode: SKPixelSpriteNode {
    var defaultTexture: SKTexture
    var activeTexture: SKTexture
    var text: SKLabelNode?
    
    init(textureName: String, text: String? = nil) {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .nearest
        let texturePressed = SKTexture(imageNamed: textureName+"_pressed")
        texturePressed.filteringMode = .nearest
        self.defaultTexture = texture
        self.activeTexture = texturePressed
        super.init(textureName: textureName)
        if (text != nil) {
            self.text = SKLabelNode(fontNamed: "Silkscreen")
            self.text!.text = text
            self.text!.setScale(1/10)
            self.text!.fontSize = 80
            self.text!.fontColor = SKColor.white()
            self.text!.verticalAlignmentMode = .center
            self.text!.zPosition = 1
            self.addChild(self.text!)
        }
        self.textureName = textureName
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.defaultTexture = aDecoder.decodeObject(forKey: "defaulttexture") as! SKTexture
        self.activeTexture = aDecoder.decodeObject(forKey: "activeTexture") as! SKTexture
        self.text = aDecoder.decodeObject(forKey: "text") as? SKLabelNode
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.defaultTexture, forKey: "defaultTexture")
        aCoder.encode(self.activeTexture, forKey: "activeTexture")
        aCoder.encode(self.text, forKey: "text")
        super.encode(with: aCoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = activeTexture
        if (text != nil) {
            text?.position.y = -1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) {
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.texture == activeTexture {
            action?()
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
        texture.filteringMode = .nearest
        let texturePressed = SKTexture(imageNamed: textureName+"_pressed")
        texturePressed.filteringMode = .nearest
        super.init(textureName: textureName, text: text)
        self.enabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.enabled = aDecoder.decodeObject(forKey: "enabled") as! Bool
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.enabled, forKey: "enabled")
        super.encode(with: aCoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = activeTexture
        if (text != nil) {
            text?.position.y = -1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) {
                self.texture = activeTexture
                if (text != nil) {
                    text?.position.y = -1
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !enabled { // enable
            enable()
        } else { // disable
            disable()
        }
    }
    
    func disable() {
        if self.texture == activeTexture {
            action?()
            if (text != nil) {
                text?.position.y = 0
            }
            self.texture = defaultTexture
            enabled = false
        }
    }
    
    func enable() {
        if self.texture == activeTexture {
            action?()
            if (text != nil) {
                text?.position.y = -1
            }
            enabled = true
        }
    }
}

class SKPixelToggleCollectionButtonNode: SKPixelToggleButtonNode {
    
    init(type: String, icon: String, text: String) {
        super.init(textureName: "topbar_menupanel_itemcategory", text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SKPixelCatNode: SKPixelSpriteNode {
    var skinName: String
    
    init(catName: String) {
        self.skinName = catName
        super.init(textureName: self.skinName)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.skinName = aDecoder.decodeObject(forKey: "catname") as! String
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.skinName, forKey: "catname")
        super.encode(with: aCoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) {
                action?()
            }
        }
    }
    
    func liftLegs() {
        self.changeTextureTo(textureName: skinName+"_floating")
    }
    
    func stand() {
        self.changeTextureTo(textureName: skinName)
    }
    
    func closeEyes() {
        self.changeTextureTo(textureName: skinName+"_blinking")
    }
    
    func openEyes() {
        stand()
    }
    
    func pube() {
        let grownCatName = textureName.replacingOccurrences(of: "_kitten", with: "")
        self.skinName = grownCatName
        stand()
        print("pubed")
    }
}
