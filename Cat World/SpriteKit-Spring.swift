////////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright 2014 Alexis Taugeron
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////

import SpriteKit


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Factory Methods -


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Move

extension SKAction {

    public class func moveByX(deltaX: CGFloat, y deltaY: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let moveByX = animateKeyPath(keyPath:"x", byValue: deltaX, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath(keyPath:"y", byValue: deltaY, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([moveByX, moveByY])
    }

    public class func moveBy(delta: CGVector, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let moveByX = animateKeyPath(keyPath:"x", byValue: delta.dx, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath(keyPath:"y", byValue: delta.dy, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([moveByX, moveByY])
    }

    public class func moveTo(location: CGPoint, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let moveToX = animateKeyPath(keyPath:"x", toValue: location.x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveToY = animateKeyPath(keyPath:"y", toValue: location.y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([moveToX, moveToY])
    }

    public class func moveToX(x: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"x", toValue: x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func moveToY(y: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"y", toValue: y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Rotate

extension SKAction {

    public class func rotateByAngle(radians: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"zRotation", byValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func rotateToAngle(radians: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"zRotation", toValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Speed

extension SKAction {

    public class func speedBy(speed: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"speed", byValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func speedTo(speed: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"speed", toValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Scale

extension SKAction {

    public class func scaleBy(scale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return scaleXBy(xScale: scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func scaleTo(scale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return scaleXTo(xScale: scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func scaleXBy(xScale: CGFloat, y yScale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let scaleXBy = animateKeyPath(keyPath:"xScale", byValue: xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYBy = animateKeyPath(keyPath:"yScale", byValue: yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([scaleXBy, scaleYBy])
    }

    public class func scaleXTo(scale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"xScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func scaleYTo(scale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"yScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func scaleXTo(xScale: CGFloat, y yScale: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let scaleXTo = self.scaleXTo(scale: xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYTo = self.scaleYTo(scale: yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([scaleXTo, scaleYTo])
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Fade

extension SKAction {

    public class func fadeInWithDuration(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"alpha", toValue: 1, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func fadeOutWithDuration(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"alpha", toValue: 0, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func fadeAlphaBy(factor: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"alpha", byValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func fadeAlphaTo(factor: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"alpha", toValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Resize

extension SKAction {

    public class func resizeByWidth(width: CGFloat, height: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let resizeByWidth = animateKeyPath(keyPath:"width", byValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeByHeight = animateKeyPath(keyPath:"height", byValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([resizeByWidth, resizeByHeight])
    }

    public class func resizeToWidth(width: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"width", toValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func resizeToHeight(height: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"height", toValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func resizeToWidth(width: CGFloat, height: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        let resizeToWidth = self.resizeToWidth(width: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeToHeight = self.resizeToHeight(height: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)

        return SKAction.group([resizeToWidth, resizeToHeight])
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Colorize

extension SKAction {

    public class func colorizeWithColorBlendFactor(colorBlendFactor: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:"colorBlendFactor", toValue: colorBlendFactor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Damping Logic

extension SKAction {

    public class func animateKeyPath(keyPath: String, byValue initialDistance: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:keyPath, byValue: initialDistance, toValue: nil, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    public class func animateKeyPath(keyPath: String, toValue finalValue: CGFloat, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {

        return animateKeyPath(keyPath:keyPath, byValue: nil, toValue: finalValue, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    private class func animateKeyPath(keyPath: String, byValue: CGFloat!, toValue: CGFloat!, duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        var initialValue: CGFloat!
        var naturalFrequency: CGFloat = 0
        var dampedFrequency: CGFloat = 0
        var t1: CGFloat = 0
        var t2: CGFloat = 0
        var A: CGFloat = 0
        var B: CGFloat = 0
        var finalValue = toValue
        var initialDistance = byValue
        
        let animation = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in

            if initialValue == nil {

                initialValue = node.value(forKeyPath: keyPath) as! CGFloat
                initialDistance = initialDistance ?? finalValue! - initialValue!
                finalValue = finalValue ?? initialValue! + initialDistance!

                var magicNumber: CGFloat! // picked manually to visually match the behavior of UIKit
                if dampingRatio < 1 { magicNumber = 8 / dampingRatio }
                else if dampingRatio == 1 { magicNumber = 10 }
                else { magicNumber = 12 * dampingRatio }

                naturalFrequency = magicNumber / CGFloat(duration)
                dampedFrequency = naturalFrequency * sqrt(1 - pow(dampingRatio, 2))
                t1 = 1 / (naturalFrequency * (dampingRatio - sqrt(pow(dampingRatio, 2) - 1)))
                t2 = 1 / (naturalFrequency * (dampingRatio + sqrt(pow(dampingRatio, 2) - 1)))
                
                if dampingRatio < 1 {
                    A = initialDistance!
                    B = (dampingRatio * naturalFrequency - velocity) * initialDistance! / dampedFrequency
                }  else if dampingRatio == 1 {
                    A = initialDistance!
                    B = (naturalFrequency - velocity) * initialDistance!
                } else {
                    A = (t1 * t2 / (t1 - t2)) * initialDistance! * (1/t2 - velocity)
                    B = (t1 * t2 / (t2 - t1)) * initialDistance! * (1/t1 - velocity)
                }
            }

            var currentValue: CGFloat!

            if elapsedTime < CGFloat(duration) {

                if dampingRatio < 1 {
                    
                    let dampingExp:CGFloat = exp(-dampingRatio * naturalFrequency * elapsedTime)
                    let ADamp:CGFloat = A * cos(dampedFrequency * elapsedTime)
                    let BDamp:CGFloat = B * sin(dampedFrequency * elapsedTime)

                    currentValue = finalValue! - dampingExp * (ADamp + BDamp)
                }
                else if dampingRatio == 1 {
                    
                    let dampingExp: CGFloat = exp(-dampingRatio * naturalFrequency * elapsedTime)

                    currentValue = finalValue! - dampingExp * (A + B * elapsedTime)
                }
                else {

                    let ADamp:CGFloat =  A * exp(-elapsedTime/t1)
                    let BDamp:CGFloat = B * exp(-elapsedTime/t2)
                    currentValue = finalValue! - ADamp - BDamp
                }
            }
            else {

                currentValue = finalValue
            }

            node.setValue(currentValue, forKeyPath: keyPath)
        }

        if delay > 0 {

            return SKAction.sequence([SKAction.wait(forDuration: delay), animation])
        }
        else {

            return animation
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - KVC Extensions -


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: SKNode

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
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: SKSpriteNode

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
