//
//  MessageCell.swift
//
//  Created by Manoj Karki on 9/25/17.
//

import UIKit

class DataCell: UITableViewCell {

    // MARK:- IBOutlets
//
//    @IBOutlet weak var dateTimeLabel: UILabel!
//    @IBOutlet weak var newIndicator: UIImageView!
//    @IBOutlet weak var descLabel: UILabel!
//    @IBOutlet weak var selectedImageView: UIImageView!
//    @IBOutlet weak var selectedImgViewLeading: NSLayoutConstraint!
//    @IBOutlet weak var messageImgView: UIImageView!

    var cellViewModel: DataCellViewModel? {
        didSet {
          // setupUI()
        }
    }

    //MARK:- Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        newIndicator.rounded()
//        selectedImageView.rounded()
//        selectedImageView.set(borderColor: UIColor.lightGray)
//        selectedImageView.set(borderWidth: 1.0)
//        messageImgView.set(cornerRadius: 3.0)
    }

}

// MARK:- Setup

extension DataCell {
    
//    fileprivate func setupUI() {
//
//        descLabel.text = cellViewModel?.message
//        self.selectedImgViewLeading.constant = (cellViewModel?.isEditing ?? false) ? 15.0 : -17.0
//        
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
//            self.contentView.layoutIfNeeded()
//        }) { _ in }
//    }
}
