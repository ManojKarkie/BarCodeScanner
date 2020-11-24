//
//  UIView+Extensions.swift
//
//  Created by Manoj Karki on 9/17/17.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK:- variables
    
    var centerForChild: CGPoint {
        let y = self.frame.height/2
        let x = self.frame.width/2
        return CGPoint(x: x, y: y)
    }
    

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
    // MARK:- functions
    
    
    
    func set(borderWidth width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    func set(borderColor color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
   
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }

    func rounded() {
        set(cornerRadius: self.frame.height / 2)
    }

    func set(cornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func applyStandardRoundedCorner() {
        self.clipsToBounds = true
        layer.cornerRadius = 6.0
    }
    
    func setBorder(to: Any, borderWidth: CGFloat, borderColor: UIColor) {
        let borderWidth:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0
        borderWidth.toValue = to
        borderWidth.duration = 0.5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor.cgColor
        self.layer.add(borderWidth, forKey: "Width")
        self.layer.borderWidth = 0.0
    }
    
    func thinShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.40
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func slightlyCurved() {
        layer.cornerRadius = 5
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func addStandardShadow() {
        self.layer.shadowColor = UIColor(white: 0.5, alpha: 0.9).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
    
//    func addTvCellStandardShadow() {
//        let shadowColor = UIColor.init(hex: "cca8a8")
//        self.layer.addShadow(with: shadowColor)
//    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
  
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func borderline(_ borderColor: UIColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(borderLayer)
    }

    func dashedBorder() {
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        borderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 7.0).cgPath
        borderLayer.strokeColor = UIColor.darkGray.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = self.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.masksToBounds = true
        layer.addSublayer(borderLayer)
    }

    func dashBorderLight() {

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.darkGray.cgColor
        borderLayer.lineDashPattern = [3, 3]
        borderLayer.lineJoin = CAShapeLayerLineJoin(rawValue: "bevel")
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(borderLayer)
    }

    func addNormalShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
    }
    
    func addCustomShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 2.7
        self.layer.shadowOpacity = 0.1
    }

    func addThinShadow() {
        self.layer.shadowColor = UIColor.init(white: 0.85, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.4
    }
    
    func addNormalShadow(with color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
    }

    func addCustomShadowWithRoundedCorner() {
        let shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = UIColor.init(hex: "#CCA8A8").cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 3.0
        self.cornerRadius = 5.0
        self.layer.shadowPath = shadowPath
        self.layer.masksToBounds = false
    }
    
    func addCorderRadiusWithBaseBorder() {
        self.cornerRadius = 4
        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderColor = borderColor.withAlphaComponent(0.10).cgColor
        self.layer.borderWidth = 1.0
    }
    
    func addCorderRadiusWithBlackBorder() {
        self.cornerRadius = 4
        self.layer.borderColor = UIColor.black.cgColor
        //        self.layer.borderColor = borderColor.withAlphaComponent(0.10).cgColor
        self.layer.borderWidth = 1.0
    }
    
    func currentFirstReponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        
        for subview in subviews {
            if subview.isFirstResponder {
                return subview
            }
        }
        return nil
    }

    func getSubviewsOfView(view: UIView) -> [UIView] {
        var subviewArray = [UIView]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview)
            subviewArray.append(subview)
        }
        return subviewArray
    }

    func setRedGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //gradientLayer.colors = [IMPColor.theme.value, UIColor.black]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }

    func addCircularShadow(shadowColor: UIColor, blur: CGFloat, opacity: Float, offset: CGSize = CGSize.zero) {
        
        layer.masksToBounds = false
        let shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: bounds.height / 2.0)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = blur
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath

    }

    func addShadowWithCorners(shadowColor: UIColor, blur: CGFloat, opacity: Float, offset: CGSize = CGSize.zero, cornerRadius: CGFloat) {

//        layer.masksToBounds = false
//        let shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: bounds.height / 2.0)
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOffset = offset
//        layer.shadowRadius = blur
//        layer.shadowOpacity = opacity
//        layer.shadowPath = shadowPath.cgPath


           layer.masksToBounds = false
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            layer.shadowColor = shadowColor.cgColor
            layer.shadowPath = path
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = opacity
            layer.shadowRadius = blur
    }

}

// Shadow extensions

extension UIView {
    
    func addCardShadow() {
        let shadowColor = UIColor.black.withAlphaComponent(0.12)
        self.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
    }
    
    func addCardShadowThin() {
        let shadowColor = UIColor.black.withAlphaComponent(0.05)
        self.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
    }

}

extension UIImage {

    class func separatorFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func fromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func whiteTabBarBackgroundImage() -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 44.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
           
        context!.setFillColor(UIColor.white.cgColor)
           context!.fill(rect)
           
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return image
    }
    
    
    
    
    
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
    
}

extension UIImageView {
//
//    func setImage(url: URL?) {
//
//        self.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached) { (image, _, _, _) in
//            self.image = image
//        }
//
//    }
    
//    func setImageWithTransition(url: URL?, placeholder: UIImage?, transitionDuration: Double = 0.5) {
//
//          self.sd_setImage(with: url, placeholderImage: placeholder, options: .refreshCached) { (image, _, _, _) in
//              if let downloadedImage = image {
//                  UIView.transition(with: self,
//                                    duration:transitionDuration,
//                                    options: .transitionCrossDissolve,
//                                    animations: {
//                                      self.image = downloadedImage
//                  },
//                                    completion: nil)
//              }
//          }
//    }
    
}

