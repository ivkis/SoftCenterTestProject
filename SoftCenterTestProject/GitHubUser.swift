//
//  GitHubUser.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class GitHubUser: Decodable {
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
    }

    let login: String
    let avatarUrl: String
    let url: String
}
