//
//  CatSelect.swift
//  Cat World
//
//  Created by Willis Allstead on 4/15/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class CatSelect: SKNode {
    init(inScene scene: SKScene) {
        let background = SKPixelSpriteNode(textureName: "catselect_bg")
        let titleBar = SKPixelSpriteNode(textureName: "catselect_titlebar")
        let circleBackground = SKPixelSpriteNode(textureName: "catselect_circle")
        
        let leftButton = SKPixelSpriteNode(textureName: "catselect_arrow")
        let rightButton = SKPixelSpriteNode(textureName: "catselect_arrow")
        rightButton.xScale = -1
        
        let circleCropNode = SKCropNode()
        circleCropNode.maskNode = SKPixelSpriteNode(textureName: "catselect_circle_mask")
        
        let catForDisplay = SKPixelSpriteNode(textureName: "oscar")
        let catForDisplay2 = SKPixelSpriteNode(textureName: "oscar")
        catForDisplay2.position = CGPoint(x: 55, y: 0)
        
        let title = SKLabelNode(fontNamed: "Fipps-Regular")
        title.text = "FAT FELINE"
        title.setScale(1/4)
        title.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        title.verticalAlignmentMode = .Center
        
        let description = SKLabelNode(fontNamed: "Silkscreen")
        description.text = "Pick A Cat"
        description.setScale(1/4)
        description.fontColor = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        description.verticalAlignmentMode = .Center
        description.alpha = 0
        
        
        super.init()
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        self.setScale(4)
        self.zPosition = 0
        background.zPosition = 0
        description.zPosition = 1
        circleBackground.zPosition = 3
        circleCropNode.zPosition = 4
        leftButton.zPosition = 3
        rightButton.zPosition = 3
        titleBar.zPosition = 5
        title.zPosition = 6
        
        titleBar.position = CGPoint(x: background.frame.midX, y: background.frame.maxY-titleBar.frame.height/2)
        title.position = CGPoint(x: titleBar.frame.midX, y: titleBar.frame.midY)
        circleCropNode.position = circleBackground.position
        leftButton.position = CGPoint(x: circleBackground.frame.minX-5, y: circleBackground.frame.midY)
        rightButton.position = CGPoint(x: circleBackground.frame.maxX+5, y: circleBackground.frame.midY)
        
        self.addChild(background)
        self.addChild(titleBar)
        self.addChild(description)
        self.addChild(circleBackground)
        self.addChild(circleCropNode)
        self.addChild(leftButton)
        self.addChild(rightButton)
        self.addChild(title)
        
        circleCropNode.addChild(catForDisplay)
        circleCropNode.addChild(catForDisplay2)
        
//        catForDisplay.runAction(shift(left: true))
//        catForDisplay2.runAction(shift(left: true))
        let displayDescription = SKAction.group([SKAction.fadeInWithDuration(0.7),
                                 SKAction.moveToY(circleBackground.frame.maxY+8, duration: 0.7)])
        displayDescription.timingMode = .EaseOut
        description.runAction(displayDescription)
        
      
    }
    
    func shift(left left: Bool) -> SKAction {
        var multiplier: CGFloat = 1
        if left {
            multiplier = -1
        }
        let slide = SKAction.moveByX(multiplier*55, y: 0, duration: 1.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0)
        return slide
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}