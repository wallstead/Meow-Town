//
//  Menu.swift
//  Cat World
//
//  Created by Willis Allstead on 6/10/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    var panelDepth: Int!
    var topBar: SKPixelSpriteNode!
    
    // MARK: Initialization
    
    convenience init(topBar: SKPixelSpriteNode) {
        self.init()
        self.panelDepth = 0
        self.topBar = topBar
        layout()
    }
    
    func layout() {
        let mainBG = SKPixelSpriteNode(textureName: "topbar_menupanel")
        mainBG.position.y = 280
        print(topBar.frame.minY)
        print(mainBG.position.y )
        self.addChild(mainBG)
        print("test from menu")
        open()
    }
    
    func open() {
        self.runAction(SKAction.moveToY(-100, duration: 3))
    }
}
