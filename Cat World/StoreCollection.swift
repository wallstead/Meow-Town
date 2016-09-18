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
    let time: TimeInterval = 3 //0.25
//    let subPanels: [StorePanel]
    
    init(pos: CGPoint, width: CGFloat, height: CGFloat) {
        buttons = []
        
        super.init(texture: nil, color: SKColor(red: 212/255, green: 29/255, blue: 32/255, alpha: 1), size: CGSize(width: width, height: height))
        
        position = pos
        isUserInteractionEnabled = false
        anchorPoint = CGPoint(x: 0.5, y: 1)
        alpha = 0
        zPosition = -5
    }
    
    func moveIntoPlace() {
        position.y = position.y+size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubButton(button: StoreButton) { // could be a button
        buttons.append(button)
        button.position.y = CGFloat(-35*buttons.index(of: button)!)-5-button.currentHeight/2
        button.originalY = button.position.y
        addChild(button)
    }
    
    func display() { // push collection down into view (probably after button resizes)
        for eachButton in buttons {
            eachButton.isUserInteractionEnabled = false
        }
        
        //move it up so that we can animate the drop-in
        if let parentButton = parent as? StoreButton {
            self.color = parentButton.parentCollection.color.darkerColor(percent: time*0.6)
//            zPosition = -4
        }
        
        alpha = 1
        
        func show() {
            run(SKAction.moveTo(y: position.y-size.height, duration: time), completion: {
                if let parentButton = self.parent as? StoreButton { // if there is a parentbutton, resize its parent collection
                    parentButton.isUserInteractionEnabled = true
                }
                for eachButton in self.buttons {
                    eachButton.isUserInteractionEnabled = true
                }
            })
            if let parentButton = parent as? StoreButton { // if there is a parentbutton, resize its parent collection
                for eachButton in parentButton.parentCollection.buttons {
                    if eachButton.position.y < parentButton.y { // move buttons below out for now
                        eachButton.run(SKAction.moveTo(y: eachButton.position.y-size.height, duration: time))
                    }
                }
            }
        }
        
        if let grandparentButton = (parent as? StoreButton)?.parentCollection.parent as? StoreButton {
            
            grandparentButton.run(SKAction.moveBy(x: 0, y: grandparentButton.size.height, duration: time*0.6), completion: {
                show()
            })
            (parent as? StoreButton)?.parentCollection.run(SKAction.resize(byWidth: 0, height: (parent as? StoreButton)!.size.height, duration: time*0.6))
        } else {
            show()
        }
    }
    
    func hide(completion: @escaping (Void)->()) {
        for eachButton in buttons {
            eachButton.isUserInteractionEnabled = false
        }
        func hide() {
            for eachbutton in buttons {
                eachbutton.zPosition = 1
            }
            run(SKAction.moveTo(y: position.y+size.height, duration: time), completion: {
                self.alpha = 0
                completion()
                
            })
            if let parentButton = parent as? StoreButton { // if there is a parentbutton, resize its parent collection
                for eachButton in parentButton.parentCollection.buttons {
                    
                    if eachButton.position.y < parentButton.y { // move buttons below out for now
                        eachButton.run(SKAction.moveTo(y: eachButton.position.y+size.height, duration: time))
                    }
                }
            }
        }
        
        if let grandparentButton = (parent as? StoreButton)?.parentCollection.parent as? StoreButton {
            grandparentButton.isUserInteractionEnabled = false
            grandparentButton.run(SKAction.moveBy(x: 0, y: -grandparentButton.size.height, duration: time*0.6), completion: {
                 hide()
            })
            (parent as? StoreButton)?.parentCollection.run(SKAction.resize(byWidth: 0, height: -(parent as? StoreButton)!.size.height, duration: time*0.6))
        } else {
            hide()
        }
    }
    
    func onButtonEnable(enabledButton: StoreButton, completion: @escaping (Void)->()) { // to move selected button to top && others obove up.
        self.parent?.isUserInteractionEnabled = false
        print("test")
        let pointToTravelTo = -enabledButton.frame.height/2
        let currentPoint = enabledButton.position.y
        let diff = pointToTravelTo-currentPoint
        
        for button in buttons {
            button.isUserInteractionEnabled = false
            if button == enabledButton {
                button.run(SKAction.moveTo(y: pointToTravelTo, duration: time*0.6), completion: {
                    completion()
                    
                })
            } else {
                button.run(SKAction.moveBy(x: 0, y: diff, duration: time*0.6))
            }
        }
    }
    
    func onButtonDisable(disabledButton: StoreButton, completion: @escaping (Void)->()) {
        
        for button in buttons {
            button.zPosition = 1
            if button == disabledButton {
                button.run(SKAction.moveTo(y: disabledButton.originalY!, duration: time*0.6), completion: {
                    completion()
                })
            } else {
                button.run(SKAction.moveTo(y: button.originalY!, duration: time*0.6))
            }
        }
    }
}
