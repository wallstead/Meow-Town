//
//  GameScene.swift
//  Cat World
//
//  Created by Willis Allstead on 4/7/16.
//  Copyright (c) 2016 Willis Allstead. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        let camera = SKCameraNode()
        self.camera = camera;
        camera.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let wallpaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
        wallpaper.setScale(46/9)
        wallpaper.zPosition = 0
        wallpaper.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let floor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
        floor.setScale(46/9)
        floor.zPosition = 1
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY+(floor.frame.height/2))
        
        let topBar = SKPixelSpriteNode(textureName: "topbar_center", pressAction: {})
        topBar.setScale(46/18)
        topBar.zPosition = 900
        topBar.position.y = camera.frame.maxY-(topBar.frame.height/2)
        let menuButton = SKPixelButtonNode(buttonImage: "topbar_menubutton", buttonText: nil, buttonAction: {
            
        })
        menuButton.zPosition = 901
        menuButton.setScale(46/18)
        menuButton.position = CGPoint(x: topBar.frame.minX-(menuButton.frame.width/2), y: topBar.frame.midY)
        camera.addChild(topBar)
        camera.addChild(menuButton)
        
        let oscar = Cat(name: "Oscar", skin: "oscar", mood: "happy", weight: 120, inScene: self)
        self.addChild(camera)
        
        self.addChild(CatSelect(inScene: self))
        self.addChild(wallpaper)
        self.addChild(floor)
        
//        let bottom = CGPoint(x: self.frame.midX, y: self.frame.minY+50)
        
//        oscar.addActivity(SKAction.moveTo(bottom, duration: 10), priority: 1)

//        let zoomIn = SKAction.scaleTo(0.7, duration: 20)
        
        
//        
//        let charlie = Cat(name: "Charlie", skin: "oscar", mood: "happy", weight: 120, inScene: self)
//        oscar.familyNode!.addChild(charlie.familyNode!)
//        
//    
//        charlie.addActivity(SKAction.waitForDuration(1), priority: 1)
//        
//       camera.runAction(SKAction.moveByX(100, y: 0, duration: 5))
        
        
        
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
