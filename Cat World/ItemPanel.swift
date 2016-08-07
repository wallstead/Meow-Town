//
//  Menu.swift
//  Meow Town
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
        bgPanel = SKPixelSpriteNode(pixelImageNamed: "topbar_itempanel")
        bgPanel.zPosition = 1
        bgPanel.setScale(GameScene.current.scale)
        bgPanel.anchorPoint = CGPoint(x: 0.5, y: 0)
        bgPanel.position.y = camFrame.maxY-topBar.frame.height
        self.addChild(bgPanel)
        
        let burgerButton = SKPixelButtonNode(pixelImageNamed: "topbar_itempanel_itembutton")
        burgerButton.zPosition = 2
        burgerButton.position.y = burgerButton.currentHeight/2+2
        burgerButton.position.x = -2*(burgerButton.currentWidth+1)
        bgPanel.addChild(burgerButton)
        
        burgerButton.action = {
            GameScene.current.world.spawn(itemName: "burger")
        }
        
        let friesButton = SKPixelButtonNode(pixelImageNamed: "topbar_itempanel_itembutton")
        friesButton.zPosition = 2
        friesButton.position.y = friesButton.currentHeight/2+2
        friesButton.position.x = -1*(friesButton.currentWidth+1)
        bgPanel.addChild(friesButton)
        
        friesButton.action = {
            GameScene.current.world.spawn(itemName: "fries")
        }
        
        let hotdogButton = SKPixelButtonNode(pixelImageNamed: "topbar_itempanel_itembutton")
        hotdogButton.zPosition = 2
        hotdogButton.position.y = hotdogButton.currentHeight/2+2
        bgPanel.addChild(hotdogButton)
        
        hotdogButton.action = {
            GameScene.current.world.spawn(itemName: "hotdog")
        }

    }
    
   
    
    func toggle() {
        removeAllActions()
        if isOpen! {
            close()
            
        } else {
            if GameScene.current.catCam.menu.isOpen == true {
                GameScene.current.catCam.menu.close()
                GameScene.current.catCam.menuButton.enabled = false
                
            }
            open()
            
        }
    }
    
    
    func open() {
        self.zPosition = 200
        self.isOpen = true
        bgPanel.run(SKAction.moveTo(y: camFrame.maxY-topBar.frame.height-bgPanel.frame.height, duration: 0.1))
    }
    
    func close() {
        self.zPosition = 100
        self.isOpen = false
        bgPanel.run(SKAction.moveTo(y: camFrame.maxY-topBar.frame.height, duration: 0.1))
    }
    
    func update(currentTime: CFTimeInterval) {
//        print(menuIsAnimating)
    }
}
