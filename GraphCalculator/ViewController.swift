//
//  ViewController.swift
//  GraphCalculator
//
//  Created by Yanpu Wu on 9/22/16.
//  Copyright © 2016 Yanpu Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, FunctionPlottingViewDelegate {
    
    @IBOutlet weak var expressionEntryTextField: UITextField!
    @IBOutlet weak var plottingView: FunctionPlottingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expressionEntryTextField.delegate = self
        plottingView.delegate = self
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        let tapLocation = sender.locationInView(plottingView)
        plottingView.crosshairLoc = tapLocation
        plottingView.setNeedsDisplay()
        
    }
    
    @IBAction func longTapGestureRecognized(sender: UILongPressGestureRecognizer) {
        //            plottingView.showCrossHair = !plottingView.showCrossHair
        plottingView.crosshairLoc = nil
        plottingView.setNeedsDisplay()
    }
    
    @IBAction func panGestureRecognized(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began{
            plottingView.preTranslate = plottingView.translate
        }
        plottingView.translate = plottingView.preTranslate + sender.translationInView(plottingView)
        plottingView.setNeedsDisplay()
    }
    
    @IBAction func pinchGestureRecognized(sender: UIPinchGestureRecognizer) {
        let ratio =  sender.scale
        plottingView.ratio = ratio
        print(ratio)
        plottingView.setNeedsDisplay()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("called textFieldShouldReturn")
        expressionEntryTextField.resignFirstResponder()
        plottingView.setNeedsDisplay() // Forces redraw!
        return false
    }
    
    func functionToPlot() -> (Double -> Double)? {
        
        if expressionEntryTextField.text == nil {
            return nil
        }
        
        var parsedExpr : NSExpression?
        do {
            try TryCatch.tryBlock {
                parsedExpr =
                    NSExpression(format: self.expressionEntryTextField.text!)
            }
        } catch {
            return nil
        }
        
        
        func x2(x: Double) -> Double {
            let vars = ["x": x]
            return parsedExpr!.expressionValueWithObject(vars,
                context: nil).doubleValue
        }
        
        return x2
    }
    
    
}



func + (left:CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}


