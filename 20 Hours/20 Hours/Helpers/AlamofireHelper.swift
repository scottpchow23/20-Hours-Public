//
//  AlamoFireHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 7/27/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class AlamofireHelper {
    static let sharedInstance = AlamofireHelper()
    var googleSearch: [GoogleSearch] = []
    var youtubeSearch: [YoutubeSearch] = []
    
    func googleSearchRequest(searchTerm: String, completion: (()-> Void)?) {
        let apiToContact = "https://www.googleapis.com/customsearch/v1?"
            + "&key="
            + "&cx="
            + "&q="
            + searchTerm
//        print(apiToContact)
        
        Alamofire.request(.GET, apiToContact).validate().responseJSON { (response) in
            switch response.result {
                
                //error
            case .Failure(let error):
                print(error.localizedDescription)
                
                //if it works
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let jsonSearchItems = json["items"]
                    
                    self.googleSearch.removeAll()
                    
                    
                    for i in 0..<jsonSearchItems.count {
                        self.googleSearch.append(GoogleSearch(json: jsonSearchItems[i]))
                    }
                    
                    if completion != nil {
                        completion!()
                    }
                }
                
            }
        }
    }
    
    func youtubeSearchRequest(searchTerm: String, completion: (()-> Void)?) {
        let apiToContact = "https://www.googleapis.com/youtube/v3/search?part=snippet"
            + "&maxResults=50"
            + "&type=video"
            + "&videoEmbeddable=true"
            + "&key="
            + "&q="
            + searchTerm
//        print(apiToContact)
        
        Alamofire.request(.GET, apiToContact).validate().responseJSON { (response) in
            switch response.result {
                
            case .Failure(let error):
                    print(error)
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let jsonSearchItems = json["items"]
//                    print(jsonSearchItems[0])
                    
                    self.youtubeSearch.removeAll()
                    
                    for i in 0..<jsonSearchItems.count {
                        self.youtubeSearch.append(YoutubeSearch(json: jsonSearchItems[i]))
                    }
                    
                }
                
                if completion != nil {
                    completion!()
                }
                
            }
        }
    }
    
}