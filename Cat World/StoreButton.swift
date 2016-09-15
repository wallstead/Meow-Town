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
    let type: String
    
    
    init(type: String, iconName: String,text: String? = nil, jsonDict: [String:JSON]) {
        subJSONDict = jsonDict
        self.type = type
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
        type = "collection"
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
        
        if type == "item" {
            /* Present item info */
            let itemImageContainter = SKPixelSpriteNode(pixelImageNamed: "topbar_menupanel_itemimagecontainer")
            itemImageContainter.color = parentCollection.color.darkerColor(percent: 0.25)
            itemImageContainter.colorBlendFactor = 1
            itemImageContainter.zPosition = 1
            itemImageContainter.position.y = -36
            childCollection!.addChild(itemImageContainter)

            let itemImage = SKPixelSpriteNode(pixelImageNamed: subJSONDict["image name"]!.stringValue)
            itemImage.zPosition = 1
            itemImage.position.y = 6
            itemImage.setScale(2)
            itemImageContainter.addChild(itemImage)

            let itemDescription = SKLabelNode(pixelFontNamed: "Silkscreen")
            itemDescription.zPosition = 2
            itemDescription.text = subJSONDict["description"]!.stringValue
            itemDescription.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            itemDescription.verticalAlignmentMode = .center
            itemDescription.position.y = itemImageContainter.frame.minY+10
            childCollection!.addChild(itemDescription)

            let infoTable = SKNode()
            let infoDict = subJSONDict["info"]!.dictionaryValue
            let itemCost = infoDict["price"]!.intValue
            var infoCounter = 0
            for infoItem in infoDict {
                // create left side and right side bg
                let leftSide = SKSpriteNode(color: parentCollection.color.darkerColor(percent: 0.2), size: CGSize(width: itemImageContainter.frame.width/2, height: 15))
                leftSide.position.x = -leftSide.frame.width/2
                leftSide.position.y = -(CGFloat(infoCounter)*16)
                infoTable.addChild(leftSide)

                let leftInfoText = SKLabelNode(fontNamed: "Silkscreen")
                leftInfoText.zPosition = 2
                leftInfoText.text = infoItem.key
                leftInfoText.setScale(1/10)
                leftInfoText.fontSize = 80
                leftInfoText.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                leftInfoText.verticalAlignmentMode = .center
                leftInfoText.horizontalAlignmentMode = .right
                leftInfoText.position.x = leftSide.frame.width/2-6

                leftSide.addChild(leftInfoText)

                let rightSide = SKSpriteNode(color: parentCollection.color.darkerColor(percent: 0.25), size: CGSize(width: itemImageContainter.frame.width/2, height: 15))
                rightSide.position.x = rightSide.frame.width/2
                rightSide.position.y = -(CGFloat(infoCounter)*16)
                infoTable.addChild(rightSide)

                let rightInfoText = SKLabelNode(fontNamed: "Silkscreen")
                rightInfoText.zPosition = 2
                rightInfoText.text = "\(infoItem.value)"
                rightInfoText.setScale(1/10)
                rightInfoText.fontSize = 80
                rightInfoText.fontColor = SKColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                rightInfoText.verticalAlignmentMode = .center
                rightInfoText.horizontalAlignmentMode = .left
                rightInfoText.position.x = -rightSide.frame.width/2+6

                rightSide.addChild(rightInfoText)

                infoCounter += 1
            }
            childCollection!.addChild(infoTable)
            infoTable.position.y = itemImageContainter.frame.minY-8.5

            let enableButton = SKPixelToggleSliderNode(withState: subJSONDict["enabled"]!.boolValue)
            enableButton.color = parentCollection.color.darkerColor(percent: 0.25)
            enableButton.colorBlendFactor = 1
            enableButton.zPosition = 2
            enableButton.position.y = infoTable.position.y - 49.2 //infoTable.position.y - 49.35 - 18
//            enableButton.onStateChange = {
////                GameScene.current.catCam.alert(type: "warning", message: "The enabled property of this button is now set to \(enableButton.enabled!).")
//
//                if enableButton.enabled == true {
//                    let wait = infoDict.value(forKey: "regen") as! Int
//                    if GameScene.current.catCam.itemPanel.addQuickItem(itemName: collectionData.value(forKey: "image name")! as! String, waitTime: wait) == false {
//                        GameScene.current.catCam.alert(type: "error", message: "Cannot enable an item already enabled.")
//                    } else {
////                        if GameScene.current.toggleEnable(withData: data!) == true {
////                            GameScene.current.catCam.alert(type: "success", message: "Toggled.")
////                        }
//                    }
//                } else {
//                    if GameScene.current.catCam.itemPanel.removeQuickItem(itemName: collectionData.value(forKey: "image name")! as! String) == false {
//                        GameScene.current.catCam.alert(type: "error", message: "Cannot remove an item that doesn't exist.")
//                    } else {
////                        if GameScene.current.toggleEnable(withData: data!) == true {
////                            GameScene.current.catCam.alert(type: "success", message: "Toggled.")
////                        }
//                    }
//                }
//
//            }
//
            let buyButton = SKPixelButtonNode(pixelImageNamed: "basicbutton", withText: "Buy")
            buyButton.color = SKColor(colorLiteralRed: 255/255, green: 162/255, blue: 51/255, alpha: 1)
            buyButton.colorBlendFactor = 1
            buyButton.zPosition = 2
            buyButton.position.y = infoTable.position.y - 49.2
//            buyButton.action = {
////                if GameScene.current.world.score >= itemCost {
////                    if GameScene.current.attemptPurchase(withData: data!) == true {
////                        GameScene.current.catCam.alert(type: "success", message: "You successfully bought \(collectionData.value(forKey: "name")!)s.")
////                        /* TODO: Hide buyButton */
////                        buyButton.removeFromParent()
////                        collectionBG.addChild(enableButton)
////                    } else {
////                        GameScene.current.catCam.alert(type: "error", message: "An error occured when attempting to purchase \(collectionData.value(forKey: "name")!)s.")
////                    }
////                } else {
////                    GameScene.current.catCam.alert(type: "error", message: "You don't have enough calories to buy \(collectionData.value(forKey: "name")!)s.")
////                }
//            }
//            
            if subJSONDict["owned"]!.boolValue == true {
                childCollection!.addChild(enableButton)
            } else {
                childCollection!.addChild(buyButton)
            }
        } else {
            /* Present sub-items */
            let collectionData = subJSONDict
            for item in collectionData {
                let itemSubDict: [String:JSON] = collectionData[item.key]!.dictionaryValue
                var itemType = "collection"
                if itemSubDict["info"]?.dictionary != nil {
                    itemType = "item"
                }
                let itemButton = StoreButton(type: itemType, iconName: "burger", text: item.key, jsonDict: itemSubDict)
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

