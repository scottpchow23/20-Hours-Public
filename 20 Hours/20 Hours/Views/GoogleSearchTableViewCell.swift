//
//  GoogleSearchTableViewCell.swift
//  20 Hours
//
//  Created by Scott Chow on 7/27/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class GoogleSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorialLinkURLLabel: UILabel!
    @IBOutlet weak var tutorialLinkTitleLabel: UILabel!
    
    var tutorialURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
