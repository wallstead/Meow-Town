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
    
    let topBar: SKPixelSpriteNode
    var items: Items?
    var menu: Menu?
    
    var hudIsAnimating = false
    var itemPanelOpen = false
    
    init(inCamera camera: SKCameraNode) {
        
        topBar = SKPixelSpriteNode(textureName: "topbar_center", pressAction: {})
        topBar.setScale(46/18)
        topBar.zPosition = 905
        topBar.position.y = camera.frame.maxY-(topBar.frame.height/2)
        
        
        
        super.init()
        
        items = Items(inHUD: self)
        
        menu = Menu(inHUD: self)
        
        let menuButton = SKPixelButtonNode(buttonImage: "topbar_menubutton", buttonText: nil, buttonAction: {})
        menuButton.zPosition = 906
        menuButton.setScale(46/18)
        menuButton.position = CGPoint(x: topBar.frame.minX-(menuButton.frame.width/2), y: topBar.frame.midY)
        
        let itemsButton = SKPixelButtonNode(buttonImage: "topbar_itemsbutton", buttonText: nil, buttonAction: {})
        itemsButton.zPosition = 906
        itemsButton.setScale(46/18)
        itemsButton.position = CGPoint(x: topBar.frame.maxX+(itemsButton.frame.width/2), y: topBar.frame.midY)
        
        
        
        itemsButton.action = {
            if !self.hudIsAnimating {
                self.hudIsAnimating = true
                self.items!.toggle()
            }
            
//            if !self.hudIsAnimating {
//                self.hudIsAnimating = true
//                
//                func toggle() {
//                    if self.itemPanelOpen {
//                        itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: self.topBar.frame.minY+(itemPanel.frame.height/2)), duration: 0.1), completion: {
//                            self.hudIsAnimating = false
//                            self.itemPanelOpen = false
//                        })
//                    } else {
//                        itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: self.topBar.frame.minY-(itemPanel.frame.height/2)), duration: 0.1), completion: {
//                            self.hudIsAnimating = false
//                            self.itemPanelOpen = true
//                        })
//                    }
//                }
//                
//                if menu.isOpen {
//                    menu.runAction(SKAction.moveTo(CGPoint(x: menu.position.x, y: self.topBar.frame.minY+(menu.frame.height/2)), duration: 0.25), completion: {
//                        self.hudIsAnimating = false
//                        menu.isOpen = false
//                        toggle()
//                    })
//                } else {
//                    toggle()
//                }
//
//                
//            }
        }
        
        menuButton.action = {
            if !self.hudIsAnimating {
                self.hudIsAnimating = true
                self.menu!.toggle()
            }
            
            
//            if !self.hudIsAnimating {
//                self.hudIsAnimating = true
//                
//                func toggle() {
//                    if menu.isOpen {
//                        menu.close()
//                    } else {
//                        menu.open()
//                    }
//                }
//                
//                if self.itemPanelOpen {
//                    itemPanel.runAction(SKAction.moveTo(CGPoint(x: itemPanel.position.x, y: self.topBar.frame.minY+(itemPanel.frame.height/2)), duration: 0.1), completion: {
//                        self.hudIsAnimating = false
//                        self.itemPanelOpen = false
//                        toggle()
//                    })
//                } else {
//                    toggle()
//                }
//                
//                
//            }
        }
        
        self.addChild(topBar)
        self.addChild(menuButton)
        self.addChild(itemsButton)
        self.addChild(items!)
        self.addChild(menu!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}