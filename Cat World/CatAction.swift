//
//  CatAction.swift
//  Meow Town
//
//  Created by Willis Allstead on 9/24/17.
//  Copyright © 2017 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit

class CatAction {
    var importance: Int = 0
    var node: SKNode // node to do actions on
    var toExecute: ()->()
    
    init(importance: Int, node: SKNode, _ block: @escaping () -> ()) {
        self.importance = importance
        self.node = node
        self.toExecute = block
    }
    
    func run() {
        toExecute()
    }
}

extension CatAction: Comparable {
    
    static func == (lhs: CatAction, rhs: CatAction) -> Bool {
        return lhs.importance == rhs.importance
    }
    
    static func < (lhs: CatAction, rhs: CatAction) -> Bool {
        return lhs.importance < rhs.importance
    }
}
