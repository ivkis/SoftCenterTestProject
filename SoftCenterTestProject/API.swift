//
//  API.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 20/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class API {

    static let shared = API()

    fileprivate func getJSON(url: URL, params: [String: String], callback: @escaping (Any?) -> Void) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, error == nil else {
                callback(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                callback(json)
            } catch {
                print(error)
                callback(nil)
            }
        }.resume()
    }

    func getGitHubUsers(query: String, callback: @escaping ([GitHubUser]?) -> Void) {
        let asyncCallback = { (users: [GitHubUser]?) in
            DispatchQueue.main.async {
                callback(users)
            }
        }
        getJSON(url: Constants.urlGitHubInfo, params: ["q": query]) { json in
            guard let json = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            guard let results = json["items"] as? [[String: AnyObject]] else {
                asyncCallback(nil)
                return
            }
            let users = results.map { dict in GitHubUser(json: dict) }
            asyncCallback(users)
        }
    }
}
