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
        
        super.init()
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        self.setScale(4)
        self.zPosition = 0
        background.zPosition = 0
        circleBackground.zPosition = 1
        circleCropNode.zPosition = 2
        titleBar.zPosition = 4
        description.zPosition = 4
        titleBar.position = CGPoint(x: background.frame.midX, y: background.frame.maxY-titleBar.frame.height/2)
        title.zPosition = 5
        title.position = CGPoint(x: titleBar.frame.midX, y: titleBar.frame.midY)
        
        circleCropNode.position = circleBackground.position
        description.position = CGPoint(x: circleBackground.frame.midX, y: circleBackground.frame.maxY+8)
        self.addChild(background)
        self.addChild(titleBar)
        self.addChild(circleBackground)
        self.addChild(circleCropNode)
        self.addChild(title)
        self.addChild(description)
        circleCropNode.addChild(catForDisplay)
        circleCropNode.addChild(catForDisplay2)
        
        catForDisplay.runAction(shift(left: true))
        catForDisplay2.runAction(shift(left: true))
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
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