//
//  MessageView.swift
//
//  Created by Manoj Karki on 1/18/18.
//

import UIKit

enum MessageViewType: String {
    case normal = "Alert"
    case error = "Error"
    case success = "Success"
}

class MessageView: UIView {

    //MARK:-  IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var ringView: UIView!
    
    fileprivate let viewName = "MessageView"
    fileprivate let successIcon = "icon_tick_green"

    var duration: Double = 3 // secs

    fileprivate var timer: Timer?

    //MARK:- Initialization

    init() {
        let frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75.0)
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.applyStandardRoundedCorner()
      //  self.containerView.backgroundColor = IMColor.offWhiteBackground.value
        self.iconContainer.rounded()
        self.ringView.set(borderWidth: 1.0)
        self.ringView.set(borderColor: UIColor.black.withAlphaComponent(0.7))
        self.ringView.rounded()
    
        self.containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.9).cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.containerView.layer.shadowRadius = 5.0
        self.containerView.layer.shadowOpacity = 0.6
        self.containerView.layer.masksToBounds = false
    }

}

extension MessageView {
    
   fileprivate func fireTimer() {
        self.timer  = Timer.scheduledTimer(withTimeInterval: self.duration, repeats: false, block: {  timer  in
            timer.invalidate()
            self.timer = nil
            self.dissmiss()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }

}

//MARK:- Load/Presentation and Dissmissal

extension MessageView {

    fileprivate func loadFromNib() {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.viewName, bundle: bundle)

        if  let popup = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            popup.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            popup.frame = self.bounds
            addSubview(popup)
        }
    }

    func present(type: MessageViewType? = .error, message: String?) {

        self.descLabel.text = message
        if type == .success {
            self.iconImgView.image = UIImage.init(named: self.successIcon)
            self.iconContainer.backgroundColor = EventStatus.active.backgroundColor
            self.titleLabel.text = type?.rawValue
        }
    
        let window = UIApplication.shared.windows.filter { return $0.isKeyWindow }.first
        
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        window?.addSubview(self)
        window?.bringSubviewToFront(self)

        self.fireTimer()
        self.alpha = 1
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {() -> Void in
            self.containerView.transform = CGAffineTransform.identity
        }, completion: { _ in
            
        })
    }

    func dissmiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }

    }
}
