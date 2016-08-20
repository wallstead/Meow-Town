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
    var itemButtons: Array<SKPixelItemButtonNode>!
    
    // MARK: Initialization
    
    convenience init(camFrame: CGRect, topBar: SKPixelSpriteNode) {
        self.init()
        self.camFrame = camFrame
        self.topBar = topBar
        self.isOpen = false
        itemButtons = []
        
        DispatchQueue.main.async {
            self.layout()
        }
    }
    
    
    // butthole
    func layout() {
        bgPanel = SKPixelSpriteNode(pixelImageNamed: "topbar_itempanel")
        bgPanel.zPosition = 1
        bgPanel.setScale(GameScene.current.scale)
        bgPanel.anchorPoint = CGPoint(x: 0.5, y: 0)
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
                GameScene.current.catCam.menuButton.enabled = false
            }
            open()
        }
        
    }
    
    func addQuickItem(itemName: String, waitTime: Int) -> Bool {
        for itemButton in itemButtons {
            if itemButton.icon.textureName == itemName {
                return false // already exists
            }
        }
        
        let itemButton = SKPixelItemButtonNode(itemNamed: itemName, waitTime: waitTime) // add it to scene in updateButtons
        itemButton.action = {
//            GameScene.current.world.spawn(itemName: itemName)
        }
        if itemButtons.count == 5 {
            itemButtons.first!.removeFromParent()
            print("removed \(itemButtons.removeFirst())")
        }
        itemButtons.append(itemButton)
        updateButtons()
        return true
    }
    
    func removeQuickItem(itemName: String) -> Bool {
        for itemButton in itemButtons {
            if itemButton.icon.textureName == itemName {
                itemButtons.remove(at: itemButtons.index(of: itemButton)!)
                itemButton.removeFromParent()
                updateButtons()
                return true
            }
        }
        return false
    }
    
    func updateButtons() {
        let origin: CGFloat = -50
        for itemButton in itemButtons {
            if itemButton.parent == nil {
                bgPanel.addChild(itemButton)
                itemButton.zPosition = 2
            }
            itemButton.position.x = origin+(CGFloat(4-itemButtons.index(of: itemButton)!)*(itemButton.currentWidth+1))
            itemButton.position.y = itemButton.currentHeight/2+2
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
