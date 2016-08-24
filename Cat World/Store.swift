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
    var storeDataPath : String? {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url?.appendingPathComponent("store.json").path
    }
    
    var storeData: JSON?
    
    init() {
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
