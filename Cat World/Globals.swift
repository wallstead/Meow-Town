//
//  Globals.swift
//
//  Created by Benzi on 01/04/15.
//  Copyright (c) 2015 Benzi. All rights reserved.
//

import Foundation
import UIKit

func unitRandom() -> CGFloat {
    return CGFloat(drand48())
}

extension CGRect {
    func mid() -> CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    func randomPoint() -> CGPoint {
        return CGPoint(x: unitRandom()*maxX, y: unitRandom()*maxY)
    }
}
