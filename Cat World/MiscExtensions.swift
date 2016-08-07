//
//  MiscExtensions.swift
//  Meow Town
//
//  Created by Willis Allstead on 8/5/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

extension SKNode {
    var x: CGFloat {
        get {
            return position.x
        }
        set {
            position.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return position.y
        }
        set {
            position.y = newValue
        }
    }
    
    var currentWidth:CGFloat {
        get {
            return frame.width/xScale
        }
    }
    
    var currentHeight:CGFloat {
        get {
            return frame.height/yScale
        }
    }
    
    var frameInScene:CGRect {
        get {
            if let scene = self.scene {
                if let parent = self.parent {
                    let rectOriginInScene = scene.convert(self.frame.origin, from: parent)
                    return CGRect(origin: rectOriginInScene, size: self.frame.size)
                }
            }
            
            return frame
        }
    }
    
    var positionInScene:CGPoint {
        get {
            if let scene = self.scene {
                if let parent = self.parent {
                    return scene.convert(self.position, from: parent)
                }
            }
            
            return position
        }
    }
}

extension SKSpriteNode {
    
    var width: CGFloat {
        get {
            
            return size.width
        }
        set {
            
            size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            
            return size.height
        }
        set {
            
            size.height = newValue
        }
    }
}

public protocol TimeIntervalLiterals {
    var seconds: TimeInterval { get }
    
    var minutes: TimeInterval { get }
    
    var hours: TimeInterval { get }
    
    var days: TimeInterval { get }
    
    var weeks: TimeInterval { get }
}

extension TimeIntervalLiterals {
    public var minutes: TimeInterval {
        return seconds * 60
    }
    
    public var hours: TimeInterval {
        return minutes * 60
    }
    
    public var days: TimeInterval {
        return hours * 24
    }
    
    public var weeks: TimeInterval {
        return days * 7
    }
}

extension TimeIntervalLiterals {
    public var second: TimeInterval {
        return seconds
    }
    
    public var minute: TimeInterval {
        return minutes
    }
    
    public var hour: TimeInterval {
        return hours
    }
    
    public var day: TimeInterval {
        return days
    }
    
    public var week: TimeInterval {
        return weeks
    }
}

extension IntegerLiteralType: TimeIntervalLiterals {
    public var seconds: TimeInterval {
        return TimeInterval(self)
    }
}

extension FloatLiteralType: TimeIntervalLiterals {
    public var seconds: TimeInterval {
        return TimeInterval(self)
    }
}

extension CGPoint {
    func distanceFromCGPoint(point:CGPoint)->CGFloat{
        return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension String {
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex))
    }
    
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex))
    }
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
    class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
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

public extension Int {
    public func clamped(range: Range<Int>) -> Int {
        return (self < range.lowerBound) ? range.lowerBound : ((self >= range.upperBound) ? range.upperBound - 1: self)
    }
    
    public mutating func clamp(range: Range<Int>) -> Int {
        self = clamped(range: range)
        return self
    }
    
    public func clamped(v1: Int, _ v2: Int) -> Int {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    public mutating func clamp(v1: Int, _ v2: Int) -> Int {
        self = clamped(v1: v1, v2)
        return self
    }
    
    public static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
    }
    
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    public static func random(min: Int, max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension Bool {
    mutating func toggle() {
        self = !self
//        return self
    }
}
