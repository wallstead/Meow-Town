//
//  World.swift
//  Cat World
//
//  Created by Willis Allstead on 4/29/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class World: SKNode {
    let wallpaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
    let floor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
    let camera: SKCameraNode
    var cameraIsZooming = false
    var cameraIsPanning = false
    
    init(inScene scene: SKScene) {

        camera = SKCameraNode()
        scene.camera = camera
        camera.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        camera.addChild(HUD(inCamera: camera))
        
        
        wallpaper.setScale(46/9)
        wallpaper.zPosition = 0
        wallpaper.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        
        let leftWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
        leftWallPaper.setScale(46/9)
        leftWallPaper.zPosition = -2
        leftWallPaper.position = CGPoint(x: wallpaper.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.midY)
        
        let rightWallPaper = SKPixelSpriteNode(textureName: "wallpaper", pressAction: {})
        rightWallPaper.setScale(46/9)
        rightWallPaper.zPosition = -2
        rightWallPaper.position = CGPoint(x: wallpaper.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.midY)
        
        floor.setScale(46/9)
        floor.zPosition = 1
        floor.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY+(floor.frame.height/2))
        
        let leftFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
        leftFloor.setScale(46/9)
        leftFloor.zPosition = -1
        leftFloor.position = CGPoint(x: wallpaper.frame.minX-leftWallPaper.frame.width/2+107, y: scene.frame.minY+(floor.frame.height/2))
        
        let rightFloor = SKPixelSpriteNode(textureName: "floor", pressAction: {})
        rightFloor.setScale(46/9)
        rightFloor.zPosition = -1
        rightFloor.position = CGPoint(x: wallpaper.frame.maxX+rightWallPaper.frame.width/2-107, y: scene.frame.minY+(floor.frame.height/2))
        
        let bottomFloor = SKSpriteNode(color: SKColor(red: 44/255, green: 57/255, blue: 78/255, alpha: 1), size: CGSize(width: 1000, height: 1000))
        bottomFloor.zPosition = -3
        bottomFloor.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY)
        
        super.init()
        
        scene.addChild(camera)
        scene.addChild(wallpaper)
        scene.addChild(leftWallPaper)
        scene.addChild(rightWallPaper)
        scene.addChild(floor)
        scene.addChild(leftFloor)
        scene.addChild(rightFloor)
        scene.addChild(bottomFloor)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}