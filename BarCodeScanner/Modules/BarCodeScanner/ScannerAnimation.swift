//
//  ScannerAnimation.swift
//
//  Created by Manoj Karki on 9/3/19.
//

import Foundation
import UIKit

// MARK:- Object that handles scanner net animation

class ScannerAnimation: NSObject {
    
    // Shared Instance
    
    static let shared:ScannerAnimation = {
         let instance = ScannerAnimation()
         return instance
     }()
    
    lazy var animationImgView = UIImageView()
    
    // Display link
    
    fileprivate var displayLink: CADisplayLink?
    
    fileprivate var tempRect: CGRect?
    
    fileprivate var contentHeight: CGFloat?
    
    // MARK:- Setup
    
    func setup(with rect: CGRect, imageView: UIImageView, referenceView: UIView) {
        
        if self.tempRect == nil {
            
            self.tempRect = rect
            self.contentHeight = referenceView.bounds.height
            
            imageView.frame = self.tempRect ?? CGRect.zero
            self.animationImgView = imageView
            referenceView.insertSubview(imageView, at: 0)
            self.setupDisplayLink()
        }

    }
    
    private func setupDisplayLink() {
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(self.animate))
        self.displayLink?.isPaused = true
        self.displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc func animate() {

        if animationImgView.frame.maxY > contentHeight! + 20 {
            animationImgView.frame = tempRect ?? CGRect.zero
        }
    
        animationImgView.transform = CGAffineTransform(translationX: 0, y: 2).concatenating(animationImgView.transform)
    }
    
    // MARK:- Animation handlers

    func startAnimation() {
        
        if self.displayLink == nil {
            self.setupDisplayLink()
        }

        self.displayLink?.isPaused = false
    }
    
    func stopAnimation() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }

}
