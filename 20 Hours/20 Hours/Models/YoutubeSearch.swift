//
//  YoutubeSearch.swift
//  20 Hours
//
//  Created by Scott Chow on 7/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import SwiftyJSON

struct YoutubeSearch {
    let videoTitle: String
    let videoImageLink: String
    let videoID: String
    
    init(json: JSON) {
//        print(json)
        self.videoTitle = json["snippet"]["title"].stringValue
        self.videoImageLink = json["snippet"]["thumbnails"]["medium"]["url"].stringValue
        self.videoID = json["id"]["videoId"].stringValue
//        print("/n/n/n/n/n" + self.videoID)
    }
}