//
//  ITunesTrack.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class ITunesTrack: Decodable {
    enum CodingKeys: String, CodingKey {
        case trackName
        case artworkUrl = "artworkUrl100"
        case artistName
    }

    let trackName: String
    let artworkUrl: String
    let artistName: String
}
