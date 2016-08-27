//
//  Store.swift
//  Meow Town
//
//  Created by Willis Allstead on 8/21/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Store {
    var panelDepth: Int = 0
    var storeDataPath : String? {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url?.appendingPathComponent("store.json").path
    }
    var storeData: JSON?
    var storeContainer: SKSpriteNode
    
    init(origin: SKSpriteNode, container: SKSpriteNode, panel: SKPixelSpriteNode) {
        storeContainer = container
        
        /* Load/Create data */
        
        storeData = loadJSON() // load if exists
        
        if storeData == nil { // create and save if doesnt
            print("[Store] Local store data empty, copying data from default store data")
            if let path = Bundle.main.path(forResource: "defaultstore", ofType: "json") {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                    storeData = JSON(data: jsonData)
                    if saveJSON(j: storeData!) {
                        print("[Store] Saved local store data")
                    } else {
                        print("[Store] Failed to save local store data")
                    }
                } catch {
                    print("[Store] Couldn't load default data")
                }
            }
        } else {
           print("[Store] Loaded local store data") 
        }
        
        
        let storeOrigin = StoreCollection(pos: CGPoint(x: origin.position.x, y: origin.position.y), width: self.storeContainer.frame.width, height: self.storeContainer.frame.height-20)
        storeOrigin.zPosition = 8
        storeContainer.addChild(storeOrigin)
        
        
        let collectionData = self.storeData!["Store"].dictionaryValue
        for item in collectionData {
            let itemSubDict: [String:JSON] = collectionData[item.key]!.dictionaryValue
            let itemButton = StoreButton(type: "collection", iconName: "burger", text: item.key, jsonDict: itemSubDict)
            itemButton.parentCollection = storeOrigin
            storeOrigin.addSubButton(button: itemButton)
        }
        storeOrigin.moveIntoPlace()
        storeOrigin.display()

        
        /* Display Content */
        let queue = DispatchQueue(label: "com.meowtown.myqueue")
        queue.async {
//            self.displayCollection(parent: origin)
            
            // use base data to add buttons to collection. Then each button should be able to do their own work from here
        }

    }
    
    func displayCollection(parent: SKSpriteNode, withData data: Dictionary<String, JSON>? = nil) {
        
//        let shiftTime = 0.3
//        let timeMode: SKActionTimingMode = .easeOut
//
//        var collectionData: [String:JSON]
//        if data != nil {
//            collectionData = data!
//        } else {
//            collectionData = self.storeData!["Store"].dictionaryValue
//        }
//        
//        if panelDepth > 1 {
//            let move = SKAction.moveTo(y: 15, duration: shiftTime/2)
//            move.timingMode = timeMode
//            parent.parent?.parent?.parent?.run(move)
//        }
//
//        let collectionBG = SKSpriteNode()
//        collectionBG.size = CGSize(width: storeContainer.frame.width, height: bgPanel.currentHeight-23-20-70)
//        collectionBG.color = SKColor(colorLiteralRed: 182/255, green: 24/255, blue: 25/255, alpha: 1).darkerColor(percent: 0.125*Double(panelDepth))
//        collectionBG.name = "collectionBG"
//        collectionBG.zPosition = -7
//        collectionBG.anchorPoint = CGPoint(x: 0.5, y: 1)
//        collectionBG.position.y = collectionBG.size.height-parent.currentHeight/2
//        collectionBG.isUserInteractionEnabled = false
//
//        parent.addChild(collectionBG)
//        
//        let showCollection = SKAction.moveTo(y: -parent.currentHeight/2, duration: shiftTime)
//        showCollection.timingMode = timeMode
//        collectionBG.run(showCollection, completion: {
//            parent.isUserInteractionEnabled = true
//        })
//        
//        var yPosCounter: CGFloat = 0
//        
//        let collection = SKNode()
//        collection.name = "collection"
//        collection.isUserInteractionEnabled = false
//        
//        var itemButtons: [StoreSubItem] = []
//        
//        for item in collectionData {
//            let itemButton: StoreSubItem
//            var itemSubDict: [String:JSON] = collectionData[item.key]!.dictionaryValue
//            itemButton = StoreSubItem(type: "collection", iconName: "burger", text: item.key, jsonDict: itemSubDict)
//            itemButton.name = "itemButton"
//            itemButtons.append(itemButton)
//            itemButton.zPosition = 1
//            itemButton.position.y = (-35*yPosCounter)-5-itemButton.currentHeight/2
//            itemButton.isUserInteractionEnabled = false
//            itemButton.run(SKAction.wait(forDuration: shiftTime), completion: {
//                itemButton.isUserInteractionEnabled = true
//            })
//            collection.addChild(itemButton)
//
//            yPosCounter += 1
//
//            
//            
////            itemButton.onPress = { [unowned self] in
////                
////            }
////            
////            itemButton.onCancel = { [unowned self] in// when the touch moved out of the button
////                
////            }
////            
////            itemButton.action = { [unowned self] in
////                
////            }
//            
//            /* 
//             Alternative:
//             
//             Create a different class for the SKPixelCollectionToggleButtonNode (and shorten name) (SKPixelCollectionNode?)
//                Make it:
//                - 
// 
//             */
//        }
//        collectionBG.addChild(collection)

    }
    
    func saveJSON(j: JSON) -> Bool {
        if storeDataPath != nil {
            do {
                try j.rawString()!.write(toFile: storeDataPath!, atomically: true, encoding: String.Encoding.utf8)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    func loadJSON() -> JSON? {
        if storeDataPath != nil {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: storeDataPath!) {
                do {
                    let contentString = try String(contentsOfFile: storeDataPath!, encoding: String.Encoding.utf8)
                    return JSON.parse(contentString)
                } catch {
                    return nil
                }
            }
            return nil
        } else {
            return nil
        }
    }
}
