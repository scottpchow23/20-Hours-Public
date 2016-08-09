//
//  GoogleSearch.swift
//  20 Hours
//
//  Created by Scott Chow on 7/27/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import SwiftyJSON

//
//class GoogleSearch {
//    
//    var searchTitle: String
//    var searchURL: String
//    var searchDisplayLink: String
//    
//    init() {
//        searchTitle = ""
//        searchURL = ""
//        searchDisplayLink = ""
//    }
//    
//    init(searchTitle: String, searchURL: String, searchDisplayLink: String) {
//        self.searchTitle = searchTitle
//        self.searchURL = searchURL
//        self.searchDisplayLink = searchDisplayLink
//    }
//    
//}

struct GoogleSearch {
    let searchTitle: String
    let searchURL: String
    let searchDisplayLink: String
    
    init(json: JSON) {
        searchTitle = json["title"].stringValue
        searchURL = json["link"].stringValue
        searchDisplayLink = json["displayLink"].stringValue
    }
}