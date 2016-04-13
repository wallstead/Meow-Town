//
//  SKPixelSpriteNode.swift
//  Cat World
//
//  Created by Willis Allstead on 4/13/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class SKPixelSpriteNode: SKSpriteNode {
    
    init(textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = SKTextureFilteringMode.Nearest
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}