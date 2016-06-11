//
//  Menu.swift
//  Cat World
//
//  Created by Willis Allstead on 6/10/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {
    var panelDepth: Int!
    
    // MARK: Initialization
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.panelDepth = decoder.decodeObjectForKey("panelDepth") as! Int
        layout()
    }
    
    convenience init(name: String) {
        self.init()
        self.panelDepth = 0
        layout()
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        if let panelDepth = panelDepth { coder.encodeObject(panelDepth, forKey: "panelDepth") }
    }
    
    func layout() {
        print("test from menu")
    }
}
