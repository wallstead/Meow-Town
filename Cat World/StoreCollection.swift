//
//  StoreCollection.swift
//  Meow Town
//
//  Created by Willis Allstead on 8/25/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class StoreCollection: SKSpriteNode {
    var buttons: [StoreButton]
//    let subPanels: [StorePanel]
    
    init(pos: CGPoint, width: CGFloat) {
        buttons = []
        super.init(texture: nil, color: SKColor.randomColor(), size: CGSize(width: width, height: 0))
        position = pos
        anchorPoint = CGPoint(x: 0.5, y: 1)
        alpha = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubButton(button: StoreButton) { // could be a button
        buttons.append(button)
        button.position.y = CGFloat(-35*buttons.index(of: button)!)-5-button.currentHeight/2
        addChild(button)
        resize()
    }
    
    func display() { // push collection down into view (probably after button resizes)
        print("displaying")
        position.y = position.y+size.height//move it up so that we can animate the drop-in
        alpha = 1
        run(SKAction.moveTo(y: position.y-size.height, duration: 0.2))
        if let parentButton = parent as? StoreButton { // if there is a parentbutton, resize its parent collection
            parentButton.parentCollection.resize(heightDiff: size.height)
            for eachButton in parentButton.parentCollection.buttons {
                if eachButton.position.y < parentButton.y { // move buttons below out for now
                    eachButton.run(SKAction.moveTo(y: eachButton.position.y-size.height, duration: 0.2))
                }
            }
        } else {
            print("nah")
        }
    }
    
    func resize(heightDiff: CGFloat? = nil) {
        print("resizing")
        if heightDiff != nil { // if height diff was precalculated
            size.height += heightDiff!
        } else { // if we just want to update the height to make sure things fit
            var newHeight: CGFloat = 5 // 5 for top padding
            
            for eachButton in buttons {
                newHeight += eachButton.frame.height + 5
            }
            
            size.height = newHeight
        }
    }
}
