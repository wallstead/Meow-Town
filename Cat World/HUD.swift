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
    init(inCamera camera: SKCameraNode) {
        
        super.init()
        
        let topBar = SKPixelSpriteNode(textureName: "topbar_center", pressAction: {})
        topBar.setScale(46/18)
        topBar.zPosition = 900
        topBar.position.y = camera.frame.maxY-(topBar.frame.height/2)
        
        let menuButton = SKPixelButtonNode(buttonImage: "topbar_menubutton", buttonText: nil, buttonAction: {})
        menuButton.zPosition = 901
        menuButton.setScale(46/18)
        menuButton.position = CGPoint(x: topBar.frame.minX-(menuButton.frame.width/2), y: topBar.frame.midY)
        
        let itemsButton = SKPixelButtonNode(buttonImage: "topbar_itemsbutton", buttonText: nil, buttonAction: {})
        itemsButton.zPosition = 901
        itemsButton.setScale(46/18)
        itemsButton.position = CGPoint(x: topBar.frame.maxX+(itemsButton.frame.width/2), y: topBar.frame.midY)

        
        
        
        self.addChild(topBar)
        self.addChild(menuButton)
        self.addChild(itemsButton)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}