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
    internal var pressAction: () -> Void
    
    
    init(textureName: String, pressAction: () -> Void) {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = SKTextureFilteringMode.Nearest
        self.pressAction = pressAction
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pressAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SKPixelButtonNode: SKPixelSpriteNode {
    var defaultButton: SKTexture
    var activeButton: SKTexture
    var buttonDown: SKAudioNode
    var buttonUp: SKAudioNode
    var text: SKLabelNode?
    internal var action: () -> Void
    

    
    init(buttonImage: String, buttonText: String?, buttonAction: () -> Void) {
        let activeButtonImage = buttonImage+"_pressed"
        defaultButton = SKTexture(imageNamed: buttonImage)
        defaultButton.filteringMode = SKTextureFilteringMode.Nearest
        activeButton = SKTexture(imageNamed: activeButtonImage)
        activeButton.filteringMode = SKTextureFilteringMode.Nearest
        buttonDown = SKAudioNode(fileNamed: "button_down.wav")
        buttonDown.autoplayLooped = false
        buttonDown.positional = false
        buttonUp = SKAudioNode(fileNamed: "button_up.wav")
        buttonUp.autoplayLooped = false
        buttonUp.positional = false
        action = buttonAction
        
        
        super.init(textureName: buttonImage, pressAction: {})
        
        userInteractionEnabled = true
        self.addChild(buttonDown)
        self.addChild(buttonUp)
        if (buttonText != nil) {
            text = SKLabelNode(fontNamed: "Silkscreen")
            
            text!.text = buttonText
            text!.setScale(1/10)
            text!.fontSize = 80
            text!.fontColor = SKColor.whiteColor()
            text!.verticalAlignmentMode = .Center
            text!.zPosition = 10
            self.addChild(text!)
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = activeButton
        buttonDown.runAction(SKAction.play())
        if (text != nil) {
            text?.position.y = -1
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.locationInNode(self.parent!)
            if self.containsPoint(location) {
                self.texture = activeButton
                if (text != nil) {
                    text?.position.y = -1
                }
            } else {
                self.texture = defaultButton
                if (text != nil) {
                    text?.position.y = 0
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.texture == activeButton {
            action()
            buttonUp.runAction(SKAction.play())
        }
        
        if (text != nil) {
            text?.position.y = 0
        }
        self.texture = defaultButton
        
    }
}

