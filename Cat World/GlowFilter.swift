//
//  GlowFilter.swift
//  based on ENHGlowFilter from http://stackoverflow.com/a/21586439/114409
//
//  Created by Matthew Hayes on 12/27/15.
//

import Foundation
import UIKit
import CoreImage

class GlowFilter : CIFilter
{
    var glowColor : UIColor!
    var glowSize : CGFloat = 1.2
    var inputImage : CIImage?
    var inputRadius : NSNumber?
    var inputCenter : CIVector?
    
    override var outputImage: CIImage?
    {
        get
        {
            guard let inputImage = inputImage else { return nil }
            
            let monochromeFilter = CIFilter(name: "CIColorMatrix")
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            var alpha : CGFloat = 0
            glowColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            monochromeFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: red), forKey: "inputRVector")
            monochromeFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: green), forKey: "inputGVector")
            monochromeFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: blue), forKey: "inputBVector")
            monochromeFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: alpha), forKey: "inputAVector")
            monochromeFilter?.setValue(inputImage, forKey: "inputImage")
            var glowImage = monochromeFilter?.outputImage
            
            let inputCenterX = inputCenter?.x ?? 0
            let inputCenterY = inputCenter?.y ?? 0
            if inputCenterX > 0
            {
                var transform = CGAffineTransform.identity.translatedBy(x: inputCenterX, y: inputCenterY)
                transform = transform.scaledBy(x: glowSize, y: glowSize)
                transform = transform.translatedBy(x: -inputCenterX, y: -inputCenterY)
                
                let affineTransformFilter = CIFilter(name: "CIAffineTransform")
                affineTransformFilter?.setDefaults()
                affineTransformFilter?.setValue(NSValue(cgAffineTransform: transform), forKey: "inputTransform")
                affineTransformFilter?.setValue(glowImage, forKey: "inputImage")
                glowImage = affineTransformFilter?.outputImage
            }
            
            let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
            gaussianBlurFilter?.setDefaults()
            gaussianBlurFilter?.setValue(glowImage, forKey: "inputImage")
            gaussianBlurFilter?.setValue(inputRadius ?? 10, forKey: "inputRadius")
            glowImage = gaussianBlurFilter?.outputImage
            
            let blendFilter = CIFilter(name: "CISourceOverCompositing")
            blendFilter?.setDefaults()
            blendFilter?.setValue(glowImage, forKey: "inputBackgroundImage")
            blendFilter?.setValue(inputImage, forKey: "inputImage")
            glowImage = blendFilter?.outputImage
            
            return glowImage
        }
    }
    
    override init()
    {
        super.init()
        glowColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        glowColor = UIColor.white
    }
    
    
}
