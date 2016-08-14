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
            label!.zPosition = 1
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

class SKPixelDraggableButtonNode: SKPixelButtonNode {
    var moved: (() -> Void)?
    var lastPosMovedTo: CGPoint?
    
    override init(pixelImageNamed name: String, withText text: String? = nil) {
        super.init(pixelImageNamed: name, withText: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
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
            if texture != pressedTexture {
                texture = pressedTexture
            }
            if label != nil && label?.position.y != -1 {
                label!.position.y = -1
            }
            lastPosMovedTo = location
            moved?()
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

        print("then here")
        if enabled != nil {
            isUserInteractionEnabled = true
            print("finally here 1")
        } else {
            isUserInteractionEnabled = false
            print("finally here 2")
        }
        
        print("enabled: \(enabled)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("enabled: \(enabled)")
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
            if enabled == true {
               self.enabled = true // reset
            } else {
                self.enabled = false
                onCancel?() // reset and run cancel
            }
        } else if enabled == nil && texture == defaultTexture {// if nil, but texture is default, set to
            print("got here")
            enabled = true
            
        }
    }
    
    func reset() { // resets to nil, so touches are canceled, then is recalled to
        enabled = nil
        print("reseting")
    }
}

class SKPixelToggleSliderNode: SKPixelToggleButtonNode {
    let toggleSwitch: SKPixelDraggableButtonNode
    var onStateChange: (() -> Void)?
    
    init(withState state: Bool) {
        toggleSwitch = SKPixelDraggableButtonNode(pixelImageNamed: "toggleswitch", withText: "OFF")
        super.init(pixelImageNamed: "basicttoggle")
        enabled = state
        toggleSwitch.label?.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        toggleSwitch.color = SKColor(red: 223/255, green: 51/255, blue: 41/255, alpha: 1) //SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        toggleSwitch.colorBlendFactor = 1
        toggleSwitch.zPosition = 1
        toggleSwitch.position.x = -size.width/2 + 21 // max x
        toggleSwitch.moved = {
            self.toggleSwitchMoved()
        }
        toggleSwitch.action = {
            self.snapSwitch()
        }
        addChild(toggleSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        toggleSwitch = SKPixelDraggableButtonNode(pixelImageNamed: "toggleswitch", withText: "OFF")
        super.init(coder: aDecoder)
        enabled = aDecoder.decodeBool(forKey: "enabled")
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(enabled, forKey: "enabled")
        super.encode(with: aCoder)
    }
    
    func toggleSwitchMoved() {
        if toggleSwitch.lastPosMovedTo!.x < size.width/2 - 21 && toggleSwitch.lastPosMovedTo!.x > -size.width/2 + 21 {
            toggleSwitch.run(SKAction.moveTo(x: toggleSwitch.lastPosMovedTo!.x, duration: 0.05))
        } else { // out of bounds
            if toggleSwitch.lastPosMovedTo!.x >= 0 { // snap to right
                toggleSwitch.run(SKAction.moveTo(x: size.width/2 - 21, duration: 0.1))
            } else {
                toggleSwitch.run(SKAction.moveTo(x: -size.width/2 + 21, duration: 0.1))
            }
        }
    }
    
    func snapSwitch() {
        func snapRight() {
            toggleSwitch.run(SKAction.moveTo(x: size.width/2 - 21, duration: 0.1))
        }
        
        func snapLeft() {
            toggleSwitch.run(SKAction.moveTo(x: -size.width/2 + 21, duration: 0.1))
        }
        
        if enabled == true { // on right
            if toggleSwitch.position.x <= 0 || toggleSwitch.position.x > size.width/2 - 27 { // snap to right
                snapLeft()
                enabled = false
            } else {
                snapRight()
                enabled = true
            }
        } else {
            if toggleSwitch.position.x >= 0 || toggleSwitch.position.x < -size.width/2 + 27 { // snap to right
                snapRight()
                enabled = true
            } else {
                snapLeft()
                enabled = false
            }
        }
        
    }
    
    override func updateState() { // called when enabled member is set programatically
        if enabled == true {
            isUserInteractionEnabled = true
            toggleSwitch.label?.text = "ON"
            toggleSwitch.color = SKColor(red: 0/255, green: 187/255, blue: 125/255, alpha: 1)
        } else if enabled == false {
            isUserInteractionEnabled = true
            toggleSwitch.label?.text = "OFF"
            toggleSwitch.color = SKColor(red: 223/255, green: 51/255, blue: 41/255, alpha: 1)
        } else {
            isUserInteractionEnabled = false
        }
        onStateChange?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("test")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

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
