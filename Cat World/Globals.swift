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
        return CGPointMake(midX, midY)
    }
    
    func randomPoint() -> CGPoint {
        return CGPointMake(unitRandom()*maxX, unitRandom()*maxY)
    }
}