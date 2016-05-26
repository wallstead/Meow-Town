//
//  MenuPanel.swift
//  Cat World
//
//  Created by Willis Allstead on 5/20/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    
    var menuPanel: SKPixelSpriteNode
    let hud: HUD
    var isOpen: Bool
    var currentDepth: Int
    
    init(inHUD hud: HUD) {
        self.hud = hud
        
        isOpen = false
        currentDepth = 0
        
        menuPanel = SKPixelSpriteNode(textureName: "topbar_menupanel", pressAction: {})
        menuPanel.setScale(46/18)
        menuPanel.zPosition = 901
        menuPanel.position.y = hud.topBar.frame.minY+(menuPanel.frame.height/2)
        
        super.init()
        
        let settingsButton = SKPixelButtonNode(buttonImage: "topbar_menupanel_settingsbutton", buttonText: nil, buttonAction: {
            print("settings")
        })
        settingsButton.zPosition = 1
        settingsButton.position = pointRelativeToCamera(CGPoint(x: menuPanel.frame.minX, y: menuPanel.frame.maxY),
                                                        xOffset: settingsButton.frame.width/2,
                                                        yOffset: -settingsButton.frame.height/2)
        
        let infoButton = SKPixelButtonNode(buttonImage: "topbar_menupanel_infobutton", buttonText: nil, buttonAction: {
            print("info")
        })
        infoButton.zPosition = 1
        infoButton.position = pointRelativeToCamera(CGPoint(x: menuPanel.frame.midX, y: menuPanel.frame.maxY),
                                                        xOffset: 0,
                                                        yOffset: -infoButton.frame.height/2)
        
        let iapButton = SKPixelButtonNode(buttonImage: "topbar_menupanel_iapbutton", buttonText: nil, buttonAction: {
            print("iap")
        })
        iapButton.zPosition = 1
        iapButton.position = pointRelativeToCamera(CGPoint(x: menuPanel.frame.maxX, y: menuPanel.frame.maxY),
                                                    xOffset: -iapButton.frame.width/2,
                                                    yOffset: -iapButton.frame.height/2)
        
        self.addChild(menuPanel)
        menuPanel.addChild(settingsButton)
        menuPanel.addChild(infoButton)
        menuPanel.addChild(iapButton)
        
        present(currentDepth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        if hud.items!.isOpen {
            hud.items!.close()
        }
        
        if isOpen {
            close()
        } else {
            open()
        }
    }
    
    func present(depth: Int) {
        for index in 0...5 {
            let nextButton = SKPixelMenuButtonNode(buttonIcon: "red", UIType: "category", buttonText: String(index), buttonAction: {
                
            })
            nextButton.zPosition = 1
            nextButton.position = pointRelativeToCamera(CGPoint(x: menuPanel.frame.midX, y: menuPanel.frame.maxY-115-CGFloat(index*95)),
                                                        xOffset: 0,
                                                        yOffset: 0)
            print(index)
            menuPanel.addChild(nextButton)
        }
        
        
        
        
    }
    
    func open() {
        menuPanel.runAction(SKAction.moveTo(CGPoint(x: menuPanel.position.x, y: hud.topBar.frame.minY-(menuPanel.frame.height/2)), duration: 0.25), completion: {
            self.isOpen = true
            self.hud.hudIsAnimating = false
        })
    }
    
    func close() {
        menuPanel.runAction(SKAction.moveTo(CGPoint(x: menuPanel.position.x, y: hud.topBar.frame.minY+(menuPanel.frame.height/2)), duration: 0.25), completion: {
            self.isOpen = false
            self.hud.hudIsAnimating = false
        })
    }
    
    func pointRelativeToCamera(point: CGPoint, xOffset: CGFloat, yOffset: CGFloat ) -> CGPoint {
        var newPoint = convertPoint(point, toNode: menuPanel)
        newPoint.x += xOffset
        newPoint.y += yOffset
        
        return newPoint
    }
}