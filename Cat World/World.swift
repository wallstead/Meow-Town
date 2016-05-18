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
        
        floor.setScale(46/9)
        floor.zPosition = 1
        floor.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY+(floor.frame.height/2))
        
        super.init()
        
        scene.addChild(camera)
        scene.addChild(wallpaper)
        scene.addChild(floor)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}