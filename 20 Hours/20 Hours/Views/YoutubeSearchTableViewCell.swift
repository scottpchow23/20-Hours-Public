//
//  YoutubeSearchTableViewCell.swift
//  20 Hours
//
//  Created by Scott Chow on 7/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubeSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!

    @IBOutlet weak var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
