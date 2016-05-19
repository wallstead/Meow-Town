//
//  HUD.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    
    var menuIsAnimating = false
    var itemPanelOpen = false
    
    init(inCamera camera: SKCameraNode) {
        
        super.init()
        
        let topBar = SKPixelSpriteNode(textureName: "topbar_center", pressAction: {})
        topBar.setScale(46/18)
        topBar.zPosition = 905
        topBar.position.y = camera.frame.maxY-(topBar.frame.height/2)
        
        let menuButton = SKPixelButtonNode(buttonImage: "topbar_menubutton", buttonText: nil, buttonAction: {})
        menuButton.zPosition = 906
        menuButton.setScale(46/18)
        menuButton.position = CGPoint(x: topBar.frame.minX-(menuButton.frame.width/2), y: topBar.frame.midY)
        
        let itemsButton = SKPixelButtonNode(buttonImage: "topbar_itemsbutton", buttonText: nil, buttonAction: {})
        itemsButton.zPosition = 906
        itemsButton.setScale(46/18)
        itemsButton.position = CGPoint(x: topBar.frame.maxX+(itemsButton.frame.width/2), y: topBar.frame.midY)
        
        let itemPanel = SKPixelSpriteNode(textureName: "topbar_itempanel", pressAction: {})
        itemPanel.setScale(46/18)
        itemPanel.zPosition = 900
        itemPanel.position.y = topBar.frame.minY+(itemPanel.frame.height/2) // -> topBar.frame.minY-(itemPanel.frame.height/2)
        
        itemsButton.action = {
            if !self.menuIsAnimating {
                self.menuIsAnimating = true
                
                if self.itemPanelOpen {
                    itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: topBar.frame.minY+(itemPanel.frame.height/2)), duration: 0.1), completion: {
                        self.menuIsAnimating = false
                        self.itemPanelOpen = false
                    })
                } else {
                    itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: topBar.frame.minY-(itemPanel.frame.height/2)), duration: 0.1), completion: {
                        self.menuIsAnimating = false
                        self.itemPanelOpen = true
                    })
                }
                
            }
        }
        
        self.addChild(topBar)
        self.addChild(menuButton)
        self.addChild(itemsButton)
        self.addChild(itemPanel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}