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

extension UIColor {
    /**
     Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
     
     :param: rgbValue RGB value
     :param: alpha color alpha value
     
     :returns: an UIColor instance that represent the required color
     */
    class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     Returns a lighter color by the provided percentage
     
     :param: lighting percent percentage
     :returns: lighter UIColor
     */
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker UIColor
     */
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}
