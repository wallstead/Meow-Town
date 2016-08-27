//
//  StoreSubItem.swift
//  Meow Town
//
//  Created by Willis Allstead on 8/25/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class StoreButton: SKPixelToggleButtonNode {
    let overlay: SKPixelSpriteNode
    let icon: SKPixelSpriteNode
    var onPress: (() -> Void)?
    var onCancel: (() -> Void)?
    let subJSONDict: [String:JSON] // prepolutated json that will be used on enable to create sub buttons
    var parentCollection: StoreCollection!
    var childCollection: StoreCollection?
    var originalY: CGFloat?
    
    
    init(type: String, iconName: String,text: String? = nil, jsonDict: [String:JSON]) {
        subJSONDict = jsonDict
        if type == "collection" || type == "item" {
            overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon = SKPixelSpriteNode(pixelImageNamed: iconName)
        } else {
            print("unrecognized type of button")
            overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon = SKPixelSpriteNode(pixelImageNamed: "burger")
        }
        super.init(pixelImageNamed: "topbar_menupanel_itemcategory", withText: text)
        
        overlay.zPosition = 1
        addChild(overlay)
        icon.zPosition = 2
        icon.position.x = -46.5
        icon.position.y = 0.5
        addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // FIXME: these need to be set dyanamically
        overlay = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
        icon = SKPixelSpriteNode(pixelImageNamed: "burger")
        subJSONDict = ["test":JSON(Data())]
        super.init(coder: aDecoder)
        
        
        overlay.zPosition = 1
        addChild(overlay)
        icon.zPosition = 2
        icon.position.x = -46.5
        icon.position.y = 0.5
        addChild(icon)
    }

    override func encode(with aCoder: NSCoder) {
        //        aCoder.encode(enabled, forKey: "enabled")
        //        super.encode(with: aCoder)
    }

    override func updateState() { // called when enabled member is set programatically
        texture = defaultTexture
        if label != nil {
            label!.position.y = 0
            overlay.position.y = 0
            icon.position.y = 0.5
        }
        if enabled == false && size.width > 122.0 {
            print("shno")
            overlay.texture = SKTexture(pixelImageNamed: "topbar_menupanel_itemcategory_ui")
            icon.run(SKAction.fadeIn(withDuration: 0.1))
            if childCollection != nil {
                childCollection!.hide(completion: {
                    let resize = SKAction.resize(toWidth: 122.0, duration: 0.1)
                    resize.timingMode = .easeIn
                    self.run(resize)
                    self.parentCollection.onButtonDisable(disabledButton: self, completion: {
                        for button in self.parentCollection.buttons {
                            button.enabled = false // set to false instead of nil to allow interaction
                            
                        }
                    })
                })
            }
            
        } else if enabled == true && size.width <= 122.0 {
            if childCollection == nil {
                self.addChildCollection()
            }
            
            parentCollection.onButtonEnable(enabledButton: self , completion: {
                self.childCollection?.display()
                
            })
            
            let resize = SKAction.resize(toWidth: 170, duration: 0.1)
            resize.timingMode = .easeIn
            run(resize, completion: {
                
            })
            overlay.texture = SKTexture(pixelImageNamed: "topbar_menupanel_itemcategory_ui2")
            icon.run(SKAction.fadeOut(withDuration: 0.1))
        } else {
            isUserInteractionEnabled = true // for when the user cancels a touch
        }
    }
    
    func addChildCollection() {
        zPosition = 4
        let nextCollectionHeight: CGFloat
        if ((parentCollection.parent as? StoreButton) != nil) {
            nextCollectionHeight = parentCollection.size.height
        } else {
            nextCollectionHeight = parentCollection.size.height-frame.height
        }
        childCollection = StoreCollection(pos: CGPoint(x: 0, y: -frame.height/2), width: parentCollection.frame.width, height: nextCollectionHeight)
        childCollection?.zPosition = -3
        addChild(childCollection!)
        
        if let infoDict =  subJSONDict["info"]?.dictionary {
            /* Present item info */
           
        } else {
            /* Present sub-items */
            let collectionData = subJSONDict
            for item in collectionData {
                let itemSubDict: [String:JSON] = collectionData[item.key]!.dictionaryValue
                let itemButton = StoreButton(type: "collection", iconName: "burger", text: item.key, jsonDict: itemSubDict)
                itemButton.parentCollection = childCollection
                childCollection?.addSubButton(button: itemButton)
            }
        }
        
        childCollection?.moveIntoPlace()  
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if enabled != nil {
            onPress?()
            // make sure other buttons are disabled
            for button in parentCollection.buttons {
                if button != self {
                    button.reset()
                }
            }
            texture = pressedTexture
            label!.position.y = -1
            overlay.position.y = -1
            icon.position.y = -0.5
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self.parent!)
            if self.contains(location) { // still inside bounds
                if enabled != nil {
                    texture = pressedTexture
                    label!.position.y = -1
                    overlay.position.y = -1
                    icon.position.y = -0.5
                }
            } else {
                if enabled != nil {
                    isUserInteractionEnabled = true
                    texture = defaultTexture
                    if label != nil {
                        label!.position.y = 0
                        overlay.position.y = 0
                        icon.position.y = 0.5
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        isUserInteractionEnabled = false

        print(enabled)
        if enabled != nil && texture != defaultTexture {
            
            if enabled == false { // about to toggle to true
                self.enabled = true
                
            } else { // about to toggle to false
                self.enabled = false
            }
        } else if enabled != nil && texture == defaultTexture {
            
            if enabled == true {
                self.enabled = true // reset
            } else {
                self.enabled = false
                onCancel?() // reset and run cancel
            }
        } else if enabled == nil && texture == defaultTexture {// if nil, but texture is default, set to
            enabled = false
        }
    }
    
    func reset() { // resets to nil, so touches are canceled, then is recalled to
        enabled = nil
    }
}

