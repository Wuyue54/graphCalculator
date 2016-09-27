//
//  FunctionPlottingView.swift
//  GraphCalculator
//
//  Created by Yanpu Wu on 9/22/16.
//  Copyright © 2016 Yanpu Wu. All rights reserved.
//

import UIKit

func f(x : Double) -> Double { // (Double -> Double)
    return x * x
}

protocol FunctionPlottingViewDelegate {
    func functionToPlot() -> (Double -> Double)?
}

class FunctionPlottingView: UIView {


    var delegate : FunctionPlottingViewDelegate?
    
    var crosshairLoc : CGPoint? = CGPoint(x: 50, y: 50)
    
    var preTranslate: CGPoint = CGPoint.zero
    
    var translate: CGPoint  = CGPoint.zero
    
    var ratio: CGFloat = 1.0
    
    func drawCrosshair(rect: CGRect, transform: CGAffineTransform) {
        let inverted = CGAffineTransformInvert(transform)
        
        if delegate == nil {
            return
        }
        if crosshairLoc == nil {
            return
        }
        
        let f = delegate?.functionToPlot()
       
        if f == nil {
            
//            let label = NSString(format: "(x:%.1f, y:%.1f)", crosshairLoc!.x, crosshairLoc!.y)
//            label.drawAtPoint(crosshairLoc!, withAttributes: nil)
        }else{

            var tempHair = CGPointApplyAffineTransform(crosshairLoc!, inverted)
            let tempX = Double(tempHair.x)
            tempHair.y = CGFloat(f!(tempX))
            let label = NSString(format: "(x:%.1f, y:%.1f)", tempHair.x, tempHair.y)
            crosshairLoc!.y = CGPointApplyAffineTransform(tempHair, transform).y
            
            print(crosshairLoc)
            label.drawAtPoint(crosshairLoc!, withAttributes: nil)
        }
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: crosshairLoc!.y))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:crosshairLoc!.y))
        
        // Y Axis
        path.moveToPoint(CGPoint(x: crosshairLoc!.x, y: 0))
        path.addLineToPoint(CGPoint(x: crosshairLoc!.x, y:rect.maxY))
        
        UIColor.lightGrayColor().setStroke()
        path.stroke() // <- Does the actual drawing!!!

    }
    
    func drawFunction(rect: CGRect, transform: CGAffineTransform) {
        if delegate == nil {
            return
        }
        
        let f = delegate?.functionToPlot()
        if f == nil {
            return
        }
        

        let hShift =  translate.x / transform.a
        var prevP : CGPoint?
        var prevP2 : CGPoint?
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        
        let left = -1.0/Double(ratio)
        let right = 1.0/Double(ratio)
        let step = (right - left)/200
        let breakR = -step
        let breakL = step
        
        print("step",step)
        print("breakR",breakR)
        print("breakL",breakL)
        
        if (f!(-1).isInfinite || f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (f!(1).isInfinite || f!(1).isNaN){
            return;
        }else if (!f!(-1).isInfinite || !f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (f!(1).isInfinite || f!(1).isNaN){
            for var x = left; x <= breakR ; x += step {
                let tempX = x - Double(hShift)
                let y = f!(tempX)
                
                let p = CGPoint(x:tempX, y:y)
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
 
        }else if(f!(-1).isInfinite || f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (!f!(1).isInfinite || !f!(1).isNaN){
            print("log(x) should run into here")
            for var x = breakL; x <= right ; x += step {
                let tempX = x - Double(hShift)
                let y = f!(tempX)
                
                let p = CGPoint(x:tempX, y:y)
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }

        }
//        else if(!f!(-1).isInfinite || !f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (!f!(1).isInfinite || !f!(1).isNaN){
//            print("1/x should run into here")
//            for var x = left; x <= breakR ; x += step {
//                let tempX = x - Double(hShift)
//                let y = f!(tempX)
//                
//                let p = CGPoint(x:tempX, y:y)
//                
//                if prevP == nil {
//                    path.moveToPoint(p)
//                } else {
//                    path.addLineToPoint(p)
//                }
//                prevP = p
//            }
//            
//            for var x = breakL; x <= right; x += step {
//                let tempX = x - Double(hShift)
//                let y = f!(tempX)
//                
//                let p = CGPoint(x:tempX, y:y)
//
//                if prevP2 == nil {
//                    path2.moveToPoint(p)
//                } else {
//                    path2.addLineToPoint(p)
//                }
//                prevP2 = p
//            }
//
//            
//        }
        else{
            for var x = left; x <= right; x += step {
                let tempX = (x - Double(hShift)) / Double(ratio)
                let y = f!(x)
                print("ratio",ratio)
                print("tempX",tempX)
                print("Y", y)
                
                if(f!(x).isInfinite||f!(x).isNaN){
                    print("FUCK")    
                    continue
                }
                
                let p = CGPoint(x:x, y:y)
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
        }
        
        path.applyTransform(transform)
        path2.applyTransform(transform)
        UIColor.redColor().setStroke()
        path.stroke()
        path2.stroke()

        
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let scale = ratio * rect.width / 2
        let transform = CGAffineTransform(a: scale, b: 0, c: 0, d: -scale, tx: rect.midX+translate.x , ty: rect.midY+translate.y)
        
        
        // X Axis
        path.moveToPoint(CGPoint(x: 0.0, y: rect.midY + translate.y))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:rect.midY + translate.y))
        UIColor.blueColor().setStroke()
        
        // Y Axis
        path.moveToPoint(CGPoint(x: rect.midX + translate.x, y: 0))
        path.addLineToPoint(CGPoint(x: rect.midX + translate.x, y:rect.maxY))
        UIColor.blueColor().setStroke()
        
        path.stroke() // <- Does the actual drawing!!!
      
        // Draw the function
        drawFunction(rect, transform:transform)
        drawCrosshair(rect, transform:transform)
        
    }

}
