//
//  ITunesTrack.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class ITunesTrack {

    let trackName: String
    let artworkUrl: String
    let artistName:String

    init(json: [String: AnyObject]) {
        trackName = json["trackName"] as? String ?? ""
        artworkUrl = json["artworkUrl100"] as? String ?? ""
        artistName = json["artistName"] as? String ?? ""
    }
}
