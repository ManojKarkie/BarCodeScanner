//
//  Labels.swift
//
//  Created by Manoj Karki on 5/11/20.
//

import Foundation
import UIKit

enum StatusType {
    
    case event, serviceActivity
}

enum EventStatus: String {
    
    case active = "Active"
    case past = "Past"
    case Postponed = "Postponed"
    case cancelled = "Cancelled"
    
    var titleColor: UIColor {

        switch self {

        case .active:
            return UIColor(hex: "#60A868")
    
        case .Postponed:
            return UIColor.init(hex: "#FFA70E")
        
        case .cancelled, .past:
            return UIColor.red
        }
    }
    
    var backgroundColor: UIColor {

           switch self {

           case .active:
//            return UIColor.init(red: 233.0 / 255.0, green: 249.0 / 255.0, blue: 237.0/255.0 , alpha: 1.0)
            return UIColor.init(hex: "#E9F9ED")
       
           case .Postponed:
//            return  UIColor.init(red: 255.0 / 255.0, green: 246.0 / 255.0, blue: 231.0 / 255.0 , alpha: 1.0)
            
            return UIColor.init(hex: "#E9F9ED")
           
           case .cancelled, .past:
//            return UIColor.init(red: 251.0 / 255.0, green: 229.0 / 255.0, blue: 232.0 / 255.0 , alpha: 1.0)
            
            return UIColor.init(hex: "#E9F9ED")
           }
       }

}

class StatusLabel: UILabel {

    @IBInspectable var topInset     : CGFloat = 3.0
    @IBInspectable var bottomInset  : CGFloat = 3.0
    @IBInspectable var leftInset    : CGFloat = 12.0
    @IBInspectable var rightInset   : CGFloat = 12.0

    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.font = IMFont.init(.regular, size: .standard(.size12)).instance
      //  backgroundColor = UIColor.init(hex: "#FCDEE1")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
    }
}

extension StatusLabel {
    
    func setup(type: StatusType, statusString: String?) {
        
        guard let status = statusString else { return }
        
        if type == .event {
            if let eventStatus = EventStatus.init(rawValue: status) {
                textColor = eventStatus.titleColor
                backgroundColor = eventStatus.backgroundColor
            }
        }

    }
    
}

class VarientInsetLabel : UILabel {

    @IBInspectable var topInset     : CGFloat = 6.0
    @IBInspectable var bottomInset  : CGFloat = 6.0
    @IBInspectable var leftInset    : CGFloat = 12.0
    @IBInspectable var rightInset   : CGFloat = 12.0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rounded()
    }
}

class InsetLabel : UILabel {

    @IBInspectable var leftInset    : CGFloat = 12.0
    @IBInspectable var rightInset   : CGFloat = 12.0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += 0.0 + 0.0
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }

}

class InsetLabelWide : UILabel {

    @IBInspectable var leftInset    : CGFloat = 17.0
    @IBInspectable var rightInset   : CGFloat = 17.0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += 0.0 + 0.0
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
}

class TableViewBgLabel: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.font = IMFont.init(.medium, size: .standard(.size12)).instance
        self.textColor = IMColor.lightText.value
        self.textAlignment = .center
        self.text = ""
    }

}
