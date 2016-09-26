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
    
    var showCrossHair: Bool = true
    
    func drawCrosshair(rect: CGRect) {
        if delegate == nil {
            return
        }
        if crosshairLoc == nil {
            return
        }
        
        let f = delegate?.functionToPlot()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: crosshairLoc!.y))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:crosshairLoc!.y))
        
        // Y Axis
        path.moveToPoint(CGPoint(x: crosshairLoc!.x, y: 0))
        path.addLineToPoint(CGPoint(x: crosshairLoc!.x, y:rect.maxY))
        
        UIColor.lightGrayColor().setStroke()
        path.stroke() // <- Does the actual drawing!!!

        if f == nil {
            
            let label = NSString(format: "(x:%.1f, y:%.1f)", crosshairLoc!.x, crosshairLoc!.y)
            label.drawAtPoint(crosshairLoc!, withAttributes: nil)
        }else{
            let scale = Double(rect.width / 2.0)
            let x = (Double(crosshairLoc!.x) - Double(rect.width)/2) / scale
            let y = f!(x)
            let label = NSString(format: "(x:%.1f, y:%.1f)", x, y)
            label.drawAtPoint(crosshairLoc!, withAttributes: nil)
        }
    }
    
    func drawFunction(rect: CGRect) {
        if delegate == nil {
            return
        }
        
        let f = delegate?.functionToPlot()
        if f == nil {
            return
        }
        
        let scale = rect.width / 2.0
        var prevP : CGPoint?
        var prevP2 : CGPoint?
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        
        if (f!(-1).isInfinite || f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (f!(1).isInfinite || f!(1).isNaN){
            return;
        }else if (!f!(-1).isInfinite || !f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (f!(1).isInfinite || f!(1).isNaN){
            for var x = -1.0; x <= -0.01 ; x += 0.01 {
                let y = f!(x)
                
                var p = CGPoint(x:x, y:y)
                p.x *= scale
                p.y *= -scale
                
                p.x += rect.midX
                p.y += rect.midY
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
            UIColor.redColor().setStroke()
            path.stroke()
        }else if(f!(-1).isInfinite || f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (!f!(1).isInfinite || !f!(1).isNaN){
            print("log(x) should run into here")
            for var x = 0.01; x <= 1.0 ; x += 0.01 {
                let y = f!(x)
    
                var p = CGPoint(x:x, y:y)
                p.x *= scale
                p.y *= -scale
                
                p.x += rect.midX
                p.y += rect.midY
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
            UIColor.redColor().setStroke()
            path.stroke()
        }else if(!f!(-1).isInfinite || !f!(-1).isNaN )&&(f!(0).isInfinite||f!(0).isNaN ) && (!f!(1).isInfinite || !f!(1).isNaN){
            print("1/x should run into here")
            for var x = -1.0; x <= -0.01 ; x += 0.01 {
                let y = f!(x)
                
                var p = CGPoint(x:x, y:y)
                p.x *= scale
                p.y *= -scale
                
                p.x += rect.midX
                p.y += rect.midY
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
          
            
            for var x = 0.01; x <= 1.0 ; x += 0.01 {
                let y = f!(x)
                var p = CGPoint(x:x, y:y)
                p.x *= scale
                p.y *= -scale
                
                p.x += rect.midX
                p.y += rect.midY
                
                if prevP2 == nil {
                    path2.moveToPoint(p)
                } else {
                    path2.addLineToPoint(p)
                }
                prevP2 = p
            }
            UIColor.redColor().setStroke()
            path.stroke()
            path2.stroke()
            
        }else{
            for var x = -1.0; x <= 1.0; x += 0.01 {
                let y = f!(x)
                
                var p = CGPoint(x:x, y:y)
                p.x *= scale
                p.y *= -scale
                
                p.x += rect.midX
                p.y += rect.midY
                
                if prevP == nil {
                    path.moveToPoint(p)
                } else {
                    path.addLineToPoint(p)
                }
                prevP = p
            }
            UIColor.redColor().setStroke()
            path.stroke()

        }

    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        // X Axis
        path.moveToPoint(CGPoint(x: 0.0, y: rect.midY))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:rect.midY))
        UIColor.blueColor().setStroke()
        
        // Y Axis
        path.moveToPoint(CGPoint(x: rect.midX, y: 0))
        path.addLineToPoint(CGPoint(x: rect.midX, y:rect.maxY))
        UIColor.blueColor().setStroke()
        
        path.stroke() // <- Does the actual drawing!!!
        
        // Draw the function
        drawFunction(rect)
        if showCrossHair{
            drawCrosshair(rect)
        }
        
    }

}
