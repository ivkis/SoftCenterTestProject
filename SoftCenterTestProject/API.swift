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

    fileprivate func getJSON(url: URL, params: [String: String], callback: @escaping (Any?) -> Void) -> URLSessionTask {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error as? NSError, error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // Don't fire callback
                } else {
                    callback(nil)
                }
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                callback(json)
            } catch {
                print(error)
                callback(nil)
            }
        }
        task.resume()
        return task
    }

    func getImageFrom(url: String, callback: @escaping (UIImage?) -> Void) -> URLSessionTask? {
        let asyncCallback = { (image: UIImage?) in
            DispatchQueue.main.async {
                callback(image)
            }
        }
        guard let url = URL(string: url) else {
            asyncCallback(nil)
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                asyncCallback(image)
            } else {
                asyncCallback(nil)
            }
        }
        task.resume()
        return task
    }

    func getGitHubUsers(query: String, callback: @escaping ([GitHubUser]?) -> Void) -> URLSessionTask {
        let asyncCallback = { (users: [GitHubUser]?) in
            DispatchQueue.main.async {
                callback(users)
            }
        }
        return getJSON(url: Constants.urlGitHubInfo, params: ["q": query]) { json in
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

    func getITunesTrack(query: String, callback: @escaping ([ITunesTrack]?) -> Void) -> URLSessionTask {
        let asyncCallback = { (tracks: [ITunesTrack]?) in
            DispatchQueue.main.async {
                callback(tracks)
            }
        }
        return getJSON(url: Constants.urlITunesInfo, params: ["term": query]) { json in
            guard let json = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            guard let results = json["results"] as? [[String: AnyObject]] else {
                asyncCallback(nil)
                return
            }
            let tracks = results.map { dict in ITunesTrack(json: dict) }
            asyncCallback(tracks)
        }
    }
}
