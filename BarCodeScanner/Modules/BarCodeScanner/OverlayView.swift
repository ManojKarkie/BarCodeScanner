//
//  OverlayView.swift
//  IMEPayWallet
//
//  Created by Manoj Karki on 9/20/17.
//  Copyright © 2017 imedigital. All rights reserved.
//

import UIKit

class OverlayView: UIView {

    // MARK:- IBOutlets
    @IBOutlet weak var topLeftVLine     : UIView!
    @IBOutlet weak var topLeftHLine     : UIView!
    @IBOutlet weak var transHoleView   : UIView!
    @IBOutlet weak var topRightVLine    : UIView!
    @IBOutlet weak var topRightHLine    : UIView!
    
    @IBOutlet weak var bottomLeftVLine  : UIView!
    @IBOutlet weak var bottomLeftHLine  : UIView!
    
    @IBOutlet weak var bottomRightVLine : UIView!
    @IBOutlet weak var bottomRightHLine : UIView!
    
    lazy var scannerImage = UIImage.init(named:"scanner-net-img")
    
    var scannerImageView: UIImageView?

    // MARK:- Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        if transHoleView != nil {
            // Ensures to use the current background color to set the filling color

//            let layer = CAShapeLayer()
//            let path = CGMutablePath()
//
//            // Make hole in view's overlay
//            path.addRect(CGRect(x: transHoleView.frame.origin.x + 3.0, y: transHoleView.frame.origin.y + 3.0, width: transHoleView.bounds.width - 6.0, height: transHoleView.bounds.height - 6.0))
//            path.addRect(bounds)
//
//            layer.path = path
//            layer.fillRule = CAShapeLayerFillRule.evenOdd
//            self.layer.mask = layer
            
            // For hole effect
            
            UIColor.black.withAlphaComponent(0.6).setFill()
            UIRectFill(rect)
            let currentContext = UIGraphicsGetCurrentContext()
            
            currentContext?.setBlendMode(.destinationOut)
            
            let bezierPath = UIBezierPath.init(rect: self.transHoleView.frame)
            bezierPath.fill()

            currentContext?.setBlendMode(.normal)
            
            // For border line
            
            let borderBezierPath = UIBezierPath.init(rect: self.transHoleView.frame)
            
            borderBezierPath.lineWidth = 0.7
            borderBezierPath.lineCapStyle = .butt

            let borderColor = UIColor.init(red: 26.0 / 255.0, green: 60.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            
            borderColor.set()
            borderBezierPath.stroke()

            // Setup ImageView
        
            let imageView = UIImageView.init(image: self.scannerImage)
            self.scannerImageView = imageView
            
            let scanHeight = self.transHoleView.bounds.height
                        
            let rect = CGRect(x: 0, y:  -( scanHeight + 20.0 ), width: self.transHoleView.bounds.width, height:self.transHoleView.bounds.height)
            
            

            ScannerAnimation.shared.setup(with: rect, imageView: imageView, referenceView: self.transHoleView)
        } 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(transHoleView)

        for redLine in transHoleView.subviews {
            bringSubviewToFront(redLine)
        }
        transHoleView.translatesAutoresizingMaskIntoConstraints = true
        
        print("OVERLAY VIEW LAYOUTSUBVIEWS CALLED ------")
    }

}

extension OverlayView {

    func startAnimation() {
        ScannerAnimation.shared.startAnimation()
    }
    
    func stopAnimation() {
        ScannerAnimation.shared.stopAnimation()
    }

}
