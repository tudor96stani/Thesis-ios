//
//  AddBookInfoOwnerTableViewCell.swift
//  Thesis
//
//  Created by Tudor Stanila on 17/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class AddBookInfoOwnerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var requestAction: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func requestBtnPress(_ sender: Any) {
        requestAction?()
    }
    
    func setButtonDesign(isInLibrary: Bool) {
        if isInLibrary{
            self.requestBtn.isEnabled=false;
            self.requestBtn.tintColor = .gray
        }
    }
}
