//
//  Menu.swift
//  Cat World
//
//  Created by Willis Allstead on 6/10/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class ItemPanel: SKNode {
    var isOpen: Bool!
    var camFrame: CGRect!
    var topBar: SKPixelSpriteNode!
    var bgPanel: SKPixelSpriteNode!
    
    // MARK: Initialization
    
    convenience init(camFrame: CGRect, topBar: SKPixelSpriteNode) {
        self.init()
        self.camFrame = camFrame
        self.topBar = topBar
        self.isOpen = false
//        self.currentButtons = []
        
        DispatchQueue.main.async {
            self.layout()
        }
    }
    
    func layout() {
        bgPanel = SKPixelSpriteNode(textureName: "topbar_itempanel")
        bgPanel.zPosition = 1
        bgPanel.setScale(GameScene.current.scale)
        bgPanel.background.anchorPoint = CGPoint(x: 0.5, y: 0)
        bgPanel.position.y = camFrame.maxY-topBar.frame.height
        self.addChild(bgPanel)

    }
    
   
    
    func toggle() {
        removeAllActions()
        if isOpen! {
            close()
        } else {
            if GameScene.current.catCam.menu.isOpen == true {
                GameScene.current.catCam.menu.close()
            }
            open()
        }
    }
    
    
    func open() {
        self.isOpen = true
        bgPanel.run(SKAction.moveTo(y: camFrame.maxY-topBar.frame.height-bgPanel.frame.height, duration: 0.1))
    }
    
    func close() {
        self.isOpen = false
        bgPanel.run(SKAction.moveTo(y: camFrame.maxY-topBar.frame.height, duration: 0.1))
    }
    
    func update(currentTime: CFTimeInterval) {
//        print(menuIsAnimating)
    }
}
