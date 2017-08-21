//
//  GitHubUser.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class GitHubUser {

    let login: String
    let avatarUrl: String
    let url: String

    init(json: [String: AnyObject]) {
        login = json["login"] as? String ?? ""
        avatarUrl = json["avatarUrl"] as? String ?? ""
        url = json["url"] as? String ?? ""
    }
}
