//
//  DrawingInCanvasViewClass.swift
//  Adiava
//
//  Created by Tuhin Samui on 09/06/15.
//  Copyright © 2015 Tuhin Samui. All rights reserved.
//

import UIKit

class DrawingInCanvasViewClass: UIView {
    
    fileprivate lazy var canvasMainDrawingColor: UIColor = UIColor.black
    fileprivate lazy var canvasDrawingTouchLineWidth: CGFloat = 1.0
    fileprivate lazy var lastPointAccessed: CGPoint = CGPoint()
    fileprivate lazy var bezirePathForDrawing: UIBezierPath = UIBezierPath()
    fileprivate lazy var currentRunningPoints: Int = 0
    fileprivate lazy var maxPointLimit: Int = 130
    lazy var finalImageFromCanvas: UIImage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeAndMakeReadyTheCanvas()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeAndMakeReadyTheCanvas()
    }
    
    func initializeAndMakeReadyTheCanvas() {
        bezirePathForDrawing = UIBezierPath()
        bezirePathForDrawing.lineCapStyle = CGLineCap.round
        bezirePathForDrawing.lineJoinStyle = CGLineJoin.round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let lastTouchedPointCheck = touches.first{
            lastPointAccessed = lastTouchedPointCheck.location(in: self)
            currentRunningPoints = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let currentTouchedPointCheck = touches.first{
            let currentPoint = currentTouchedPointCheck.location(in: self)
            bezirePathForDrawing.move(to: lastPointAccessed)
            bezirePathForDrawing.addLine(to: currentPoint)
            lastPointAccessed = currentPoint
            currentRunningPoints = currentRunningPoints + 1
            if currentRunningPoints == maxPointLimit{
                currentRunningPoints = 0
                renderToAnImageFromCanvas()
                self.setNeedsDisplay()
                bezirePathForDrawing.removeAllPoints()
            }else{
                self.setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentRunningPoints = 0
        renderToAnImageFromCanvas()
        setNeedsDisplay()
        bezirePathForDrawing.removeAllPoints()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        if let cancelledTouchEventCheck = touches{
            touchesEnded(cancelledTouchEventCheck, with: event)
        }
    }
    
    func renderToAnImageFromCanvas() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        if let _ = finalImageFromCanvas{
            finalImageFromCanvas?.draw(in: self.bounds)
        }
        bezirePathForDrawing.lineWidth = canvasDrawingTouchLineWidth
        canvasMainDrawingColor.setFill()
        canvasMainDrawingColor.setStroke()
        bezirePathForDrawing.stroke()
        finalImageFromCanvas = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let _ = finalImageFromCanvas{
            finalImageFromCanvas?.draw(in: self.bounds)
        }
        
        bezirePathForDrawing.lineWidth = canvasDrawingTouchLineWidth
        canvasMainDrawingColor.setFill()
        canvasMainDrawingColor.setStroke()
        bezirePathForDrawing.stroke()
    }
    
    func clearTheCanvasAndReset() {
        finalImageFromCanvas = nil
        bezirePathForDrawing.removeAllPoints()
        setNeedsDisplay()
    }
    
}
