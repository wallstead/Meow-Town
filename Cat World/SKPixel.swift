//
//  SKPixelSpriteNode.swift
//  Meow Town
//
//  Created by Willis Allstead on 4/13/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: New Classes & Extensions

extension SKTexture {
    convenience init(pixelImageNamed name: String) {
        self.init(imageNamed: name)
        self.filteringMode = .nearest
    }
}

extension SKLabelNode {
    convenience init(pixelFontNamed name: String) {
        self.init(fontNamed: name)
        fontSize = 80
        setScale(1/10)
        fontColor = SKColor.white()
        verticalAlignmentMode = .center
    }
}

class SKPixelSpriteNode: SKSpriteNode {
    var textureName: String
    override var texture: SKTexture? {
        didSet {
            updateTexture()
        }
    }
    var action: (() -> Void)?
    
    init(pixelImageNamed name: String, interactionEnabled: Bool? = false) {
        let pixelTexture = SKTexture(pixelImageNamed: name)
        textureName = name
        super.init(texture: pixelTexture, color: SKColor.clear(), size: pixelTexture.size())
        if interactionEnabled == true {
            isUserInteractionEnabled = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        textureName = aDecoder.decodeObject(forKey: "textureName") as! String
        super.init(coder: aDecoder)
        texture = aDecoder.decodeObject(forKey: "texture") as? SKTexture
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(textureName, forKey: "textureName")
        aCoder.encode(texture, forKey: "texture")
        super.encode(with: aCoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?()
    }
    
    func updateTexture() { }
}

class SKPixelButtonNode: SKPixelSpriteNode {
    var defaultTexture: SKTexture
    var pressedTexture: SKTexture
    var label: SKLabelNode?
    
    init(pixelImageNamed name: String, withText text: String? = nil) {
        defaultTexture = SKTexture(pixelImageNamed: name)
        pressedTexture = SKTexture(pixelImageNamed: name+"_pressed")
        super.init(pixelImageNamed: name, interactionEnabled: true)
        if text != nil {
            label = SKLabelNode(pixelFontNamed: "Silkscreen")
            label!.text = text!
            label!.zPosition = 2
            addChild(label!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        defaultTexture = aDecoder.decodeObject(forKey: "defaultTexture") as! SKTexture
        pressedTexture = aDecoder.decodeObject(forKey: "pressedTexture") as! SKTexture
        label = aDecoder.decodeObject(forKey: "label") as? SKLabelNode
        super.init(coder: aDecoder)

    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(defaultTexture, forKey: "defaultTexture")
        aCoder.encode(pressedTexture, forKey: "pressedTexture")
        aCoder.encode(label, forKey: "label")
        super.encode(with: aCoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = pressedTexture
        if label != nil {
            label!.position.y = -1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) { // still inside bounds
                if texture != pressedTexture {
                    texture = pressedTexture
                }
                if label != nil && label?.position.y != -1 {
                    label!.position.y = -1
                }
            } else {
                if texture != defaultTexture {
                    texture = defaultTexture
                }
                if label != nil && label?.position.y != 0 {
                    label!.position.y = 0
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if texture == pressedTexture {
            action?()
        }
        if label != nil {
            label!.position.y = 0
        }
        texture = defaultTexture
    }
}

class SKPixelToggleButtonNode: SKPixelButtonNode {
    var enabled: Bool? { // will be nil if changing state
        didSet {
            updateState()
        }
    }
    
    override init(pixelImageNamed name: String, withText text: String? = nil) {
        enabled = false
        super.init(pixelImageNamed: name, withText: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        enabled = aDecoder.decodeBool(forKey: "enabled")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(enabled, forKey: "enabled")
        super.encode(with: aCoder)
    }
    
    func updateState() { // called when enabled member is set programatically
        if enabled == true {
            isUserInteractionEnabled = true
            texture = pressedTexture
            if label != nil {
                label!.position.y = -1
            }
        } else if enabled == false {
            isUserInteractionEnabled = true
            texture = defaultTexture
            if label != nil {
                label!.position.y = 0
            }
        } else {
            isUserInteractionEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // enabled -> pressedTexture
        // disabled -> defaultTexture
        if enabled == true {
            texture = defaultTexture
            if label != nil {
                label!.position.y = 0
            }
        } else if enabled == false {
            texture = pressedTexture
            if label != nil {
                label!.position.y = -1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) { // still inside bounds
                if enabled == true {
                    if texture != defaultTexture {
                        texture = defaultTexture
                    }
                    if label != nil && label?.position.y != 0 {
                        label!.position.y = 0
                    }
                } else if enabled == false {
                    if texture != pressedTexture {
                        texture = pressedTexture
                    }
                    if label != nil && label?.position.y != -1 {
                        label!.position.y = -1
                    }
                }
            } else {
                if enabled == true { // reset to enabled
                    if texture != pressedTexture {
                        texture = pressedTexture
                    }
                    if label != nil && label?.position.y != -1 {
                        label!.position.y = -1
                    }
                } else if enabled == false { // reset to disabled
                    if texture != defaultTexture {
                        texture = defaultTexture
                    }
                    if label != nil && label?.position.y != 0 {
                        label!.position.y = 0
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if enabled != nil {
            enabled!.toggle()
            action?()
        }
    }
}

class SKPixelCollectionToggleButtonNode: SKPixelToggleButtonNode {
    let overlay: SKPixelSpriteNode
    let icon: SKPixelSpriteNode
    var onPress: (() -> Void)?
    var onCancel: (() -> Void)?
    let shiftTime = 0.3
    
    init(type: String, iconNamed iconName: String, withText text: String? = nil) {
        if type == "collection" || type == "item" {
            overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon = SKPixelSpriteNode(pixelImageNamed: iconName)
        } else {
            print("unrecognized type of button")
            overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon = SKPixelSpriteNode(pixelImageNamed: "burger")
        }
        super.init(pixelImageNamed: "topbar_menupanel_itemcategory", withText: text)
        overlay.zPosition = 1
        addChild(overlay)
        icon.zPosition = 2
        icon.position.x = -46.5
        icon.position.y = 0.5
        addChild(icon)
        print(size.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // FIXME: these need to be set dyanamically
        overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
        icon = SKPixelSpriteNode(pixelImageNamed: "burger")
        super.init(coder: aDecoder)
        overlay.zPosition = 1
        addChild(overlay)
        icon.zPosition = 2
        icon.position.x = -46.5
        icon.position.y = 0.5
        addChild(icon)
        
    }
    
    override func encode(with aCoder: NSCoder) {
//        aCoder.encode(enabled, forKey: "enabled")
//        super.encode(with: aCoder)
    }
    
    override func updateState() { // called when enabled member is set programatically
        texture = defaultTexture
        if label != nil {
            label!.position.y = 0
            overlay.position.y = 0
            icon.position.y = 0.5
        }
        if enabled == false && size.width > 122.0 {
            let resize = SKAction.resize(toWidth: 122.0, duration: 0.1)
            resize.timingMode = .easeIn
            run(resize)
            overlay.texture = SKTexture(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon.run(SKAction.fadeIn(withDuration: 0.1))
        }

        if enabled != nil {
            isUserInteractionEnabled = true
        } else {
            isUserInteractionEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(enabled)
        if enabled != nil {
            onPress?()
            texture = pressedTexture
            label!.position.y = -1
            overlay.position.y = -1
            icon.position.y = -0.5
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) { // still inside bounds
                if enabled != nil {
                    texture = pressedTexture
                    label!.position.y = -1
                    overlay.position.y = -1
                    icon.position.y = -0.5
                }
            } else {
                if enabled != nil {
                    isUserInteractionEnabled = true
                    texture = defaultTexture
                    if label != nil {
                        label!.position.y = 0
                        overlay.position.y = 0
                        icon.position.y = 0.5
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        
        if enabled != nil && texture != defaultTexture {
            if enabled == false { // about to toggle to true
                enabled = nil // disable interaction
                overlay.texture = SKTexture(pixelImageNamed: "topbar_menupanel_itemcategory_ui2")
                icon.run(SKAction.fadeOut(withDuration: 0.1))
                let resize = SKAction.resize(toWidth: 168, duration: 0.1)
                resize.timingMode = .easeIn
                run(resize, completion: {
                    self.enabled = true
                    self.action?()
                })
            } else { // about to toggle to false
                enabled = nil // disable interaction
                run(SKAction.wait(forDuration: shiftTime), completion: {
                    self.overlay.texture = SKTexture(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
                    self.icon.run(SKAction.fadeIn(withDuration: 0.1))
                    let resize = SKAction.resize(toWidth: 122.0, duration: 0.1)
                    resize.timingMode = .easeIn
                    self.run(resize, completion: {
                        self.enabled = false
                    })
                })
                self.action?()
            }
        } else if enabled != nil && texture == defaultTexture {
            self.enabled = false
            onCancel?()
        }
    }
}

// MARK: Old stuff

//class SKPixelSpriteNode: SKSpriteNode {
//    var background: SKSpriteNode
//    var pixelImageNamed: String
//    internal var action: (() -> Void)?
//    internal var onPress: (() -> Void)?
//    
//    init(pixelImageNamed: String) {
//        let texture = SKTexture(pixelImageNamed: pixelImageNamed)
//        self.pixelImageNamed = pixelImageNamed
//        self.background = SKSpriteNode(texture: texture)
//        super.init(texture: nil, color: SKColor.clear(), size: texture.size())
//        self.isUserInteractionEnabled = true
//        self.addChild(self.background)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.pixelImageNamed = aDecoder.decodeObject(forKey: "pixelImageNamed") as! String
//        self.background = aDecoder.decodeObject(forKey: "background") as! SKSpriteNode
//        super.init(coder: aDecoder)
//        self.isUserInteractionEnabled = true
//    }
//    
//    override func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.pixelImageNamed, forKey: "pixelImageNamed")
//        aCoder.encode(self.background, forKey: "background")
//        super.encode(with: aCoder)
//    }
//    
//    func changeTextureTo(pixelImageNamed: String) {
//        self.background.size = CGSize(width: 0, height: 0)
//        let newTexture = SKTexture(pixelImageNamed: pixelImageNamed)
//        self.background.texture = newTexture
//        let oldXScale = background.xScale
//        let oldYScale = background.yScale
//        self.background.size.height = newTexture.size().height
//        self.background.size.width = newTexture.size().width
////        print(oldXScale)
//        self.background.xScale = oldXScale
//        self.background.yScale = oldYScale
//        
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        action?()
//    }
//}
//
//class SKPixelButtonNode: SKPixelSpriteNode {
//    var defaultTexture: SKTexture
//    var activeTexture: SKTexture
//    var text: SKLabelNode?
//    
//    init(pixelImageNamed: String, text: String? = nil, bgcolor: SKColor? = nil) {
//        let texture = SKTexture(pixelImageNamed: pixelImageNamed)
//        let texturePressed = SKTexture(pixelImageNamed: pixelImageNamed+"_pressed")
//        self.defaultTexture = texture
//        self.activeTexture = texturePressed
//        super.init(pixelImageNamed: pixelImageNamed)
//        if (text != nil) {
//            self.text = SKLabelNode(fontNamed: "Silkscreen")
//            self.text!.text = text
//            self.text!.setScale(1/10)
//            self.text!.fontSize = 80
//            self.text!.fontColor = SKColor.white()
//            self.text!.verticalAlignmentMode = .center
//            self.text!.zPosition = 1
//            self.addChild(self.text!)
//        }
//        self.pixelImageNamed = pixelImageNamed
//        self.isUserInteractionEnabled = true
//        
//        if bgcolor != nil {
//            background.color = bgcolor!
//            background.colorBlendFactor = 1
//            
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.defaultTexture = aDecoder.decodeObject(forKey: "defaulttexture") as! SKTexture
//        self.activeTexture = aDecoder.decodeObject(forKey: "activeTexture") as! SKTexture
//        self.text = aDecoder.decodeObject(forKey: "text") as? SKLabelNode
//        super.init(coder: aDecoder)
//        self.isUserInteractionEnabled = true
//    }
//    
//    override func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.defaultTexture, forKey: "defaultTexture")
//        aCoder.encode(self.activeTexture, forKey: "activeTexture")
//        aCoder.encode(self.text, forKey: "text")
//        super.encode(with: aCoder)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.background.texture = activeTexture
//        if (text != nil) {
//            text?.position.y = -1
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location: CGPoint = touch.location(in: self.parent!)
//            if self.contains(location) {
//                self.background.texture = activeTexture
//                if (text != nil) {
//                    text?.position.y = -1
//                }
//            } else {
//                self.background.texture = defaultTexture
//                if (text != nil) {
//                    text?.position.y = 0
//                }
//            }
//        }
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if self.background.texture == activeTexture {
//            action?()
//        }
//        if (text != nil) {
//            text?.position.y = 0
//        }
//        self.background.texture = defaultTexture
//    }
//}
//
//class SKPixelToggleButtonNode: SKPixelButtonNode {
//    var enabled: Bool!
//    var shownText: String? {
//        didSet {
//            updateText()
//        }
//    }
//    
//    override init(pixelImageNamed: String, text: String? = nil, bgcolor: SKColor? = nil) {
//        let texture = SKTexture(pixelImageNamed: pixelImageNamed)
//        let texturePressed = SKTexture(pixelImageNamed: pixelImageNamed+"_pressed")
//        if text != nil {
//            self.shownText = text!
//        }
//
//        super.init(pixelImageNamed: pixelImageNamed, text: text)
//        self.enabled = false
//        if bgcolor != nil {
//            background.color = bgcolor!
//            background.colorBlendFactor = 1
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.enabled = aDecoder.decodeObject(forKey: "enabled") as! Bool
//        super.init(coder: aDecoder)
//        self.isUserInteractionEnabled = true
//    }
//    
//    override func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.enabled, forKey: "enabled")
//        super.encode(with: aCoder)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.background.texture = activeTexture
//        text?.position.y = -1
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location: CGPoint = touch.location(in: self.parent!)
//            if self.contains(location) {
//                self.background.texture = activeTexture
//                text?.position.y = -1
//            }
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !enabled {
//            enable()
//        } else {
//            disable(withAction: true)
//        }
//    }
//    
//    func disable(withAction: Bool = false) {
//        if self.background.texture == activeTexture {
//            if withAction == true {
//                action?()
//            }
//            text?.position.y = 0
//            self.background.texture = defaultTexture
//            enabled = false
//        }
//    }
//    
//    func enable() {
//        if self.background.texture == activeTexture {
//            action?()
//            text?.position.y = -1
//            enabled = true
//        }
//    }
//    
//    func updateText() {
//        text?.text = shownText
//    }
//}
//
//class SKPixelToggleCollectionButtonNode: SKPixelToggleButtonNode {
//    let overlay: SKPixelSpriteNode?
//    let icon: SKPixelSpriteNode?
//    let shiftTime = 0.3
//    
//    init(type: String, iconName: String, text: String) {
//        if type == "collection" || type == "item" {
//            overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
//            icon = SKPixelSpriteNode(pixelImageNamed: iconName)
//        } else {
//            print("unrecognized type of button")
//            overlay = nil
//            icon = nil
//        }
//        
//        super.init(pixelImageNamed: "topbar_menupanel_itemcategory", text: text)
//        
//        if overlay != nil {
//            overlay!.zPosition = 2
//            overlay!.isUserInteractionEnabled = false
//            self.addChild(overlay!)
//        }
//        if icon != nil {
//            icon!.zPosition = 3
//            icon!.isUserInteractionEnabled = false
//            icon!.position.x = -46.5
//            icon!.position.y = 0.5
//            
//            
//            self.addChild(icon!)
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        onPress!()
//        self.background.texture = activeTexture
//        text?.position.y = -1
//        overlay?.position.y = -1
//        icon?.position.y = -0.5
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location: CGPoint = touch.location(in: self.parent!)
//            if self.contains(location) {
//                self.background.texture = activeTexture
//                text?.position.y = -1
//                overlay?.position.y = -1
//                icon?.position.y = -0.5
//            }
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isUserInteractionEnabled = false
//        if !enabled {
//            enable()
//        } else {
//            disable(withAction: true)
//        }
//    }
//    
//    
//    
//    override func disable(withAction: Bool) {
//        if withAction {
//            action?()
//        }
//        self.text?.position.y = 0
//        self.overlay?.position.y = 0
//        self.icon?.position.y = 0.5
//        self.background.texture = self.defaultTexture
//        
//        self.run(SKAction.wait(forDuration: shiftTime), completion: {
//            self.overlay?.run(SKAction.fadeOut(withDuration: 0.1), completion: {
//                self.overlay?.changeTextureTo(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
//                self.overlay?.run(SKAction.fadeIn(withDuration: 0.1))
//            })
//            self.icon?.run(SKAction.fadeIn(withDuration: 0.1))
//            self.background.run(SKAction.scaleX(to: 1, duration: 0.2), completion: {
//                self.isUserInteractionEnabled = true
//            })
//            
//            self.enabled = false
//        })
//    }
//    
//    override func enable() {
//        if self.background.texture == activeTexture {
//            action?()
//            text?.position.y = 0
//            overlay?.position.y = 0
//            icon?.position.y = 0.5
//            icon?.run(SKAction.fadeOut(withDuration: 0.1))
//            overlay?.run(SKAction.fadeOut(withDuration: 0.1), completion: {
//                self.overlay?.changeTextureTo(pixelImageNamed: "topbar_menupanel_itemcategory_ui2")
//                self.overlay?.run(SKAction.fadeIn(withDuration: 0.1))
//            })
//            
//            self.background.run(SKAction.scaleX(to: 1.4, duration: 0.2), completion: {
//                self.isUserInteractionEnabled = true
//            })
//            self.background.texture = defaultTexture
//            enabled = true
//        }
//    }
//}

class SKPixelCatNode: SKPixelSpriteNode {
    var skinName: String
    var colors: UIImageColors
    var mouth: SKSpriteNode
    
    init(catName: String) {
        skinName = catName
        colors = UIImage(named: skinName)!.getColors()
        mouth = SKSpriteNode(color: SKColor.clear(), size: CGSize(width: 1, height: 1))
        
        super.init(pixelImageNamed: skinName, interactionEnabled: true)
        mouth.zPosition = 1
        
        addChild(mouth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.skinName = aDecoder.decodeObject(forKey: "catname") as! String
        self.colors = UIImage(named: skinName)!.getColors()
        self.mouth = SKSpriteNode(color: SKColor.clear(), size: CGSize(width: 1, height: 1))
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(skinName, forKey: "catname")
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
        texture = SKTexture(pixelImageNamed: skinName+"_floating")
    }
    
    func stand() {
        texture = SKTexture(pixelImageNamed: skinName)
    }
    
    func closeEyes() {
        texture = SKTexture(pixelImageNamed: skinName+"_blinking")
    }
    
    func openEyes() {
        stand()
    }
    
    func pube() {
        skinName = skinName.replacingOccurrences(of: "_kitten", with: "")
        stand()
    }
    
    override func updateTexture() {
        let oldXScale = xScale
        let oldYScale = yScale
        size = CGSize(width: 0, height: 0)
        size.height = texture!.size().height
        size.width = texture!.size().width
        xScale = oldXScale
        yScale = oldYScale
        
        /* update mouth */
        if skinName.contains("_kitten") {
            mouth.position = CGPoint(x: -4.5, y: 5.5)
        } else {
            mouth.position = CGPoint(x: -12, y: 12.5)
        }
        
    }
}
