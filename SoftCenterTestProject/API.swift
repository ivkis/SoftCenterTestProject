//
//  API.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 20/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


struct JsonUsers: Decodable {
    var items: [GitHubUser]?
}

struct JsonTracks: Decodable {
    var results: [ITunesTrack]?
}


class API {

    static let shared = API()

    fileprivate func getJSON(url: URL, params: [String: String], callback: @escaping (Data?) -> Void) -> URLSessionTask {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, error == nil else {
                let nsError = error == nil ? nil : error! as NSError
                if nsError?.domain == NSURLErrorDomain && nsError?.code == NSURLErrorCancelled {
                    // Don't fire callback
                } else {
                    callback(nil)
                }
                return
            }
            callback(data)
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
        return getJSON(url: Constants.urlGitHubInfo, params: ["q": query]) { data in
            guard let data = data else {
                asyncCallback(nil)
                return
            }
            let info = try? JSONDecoder().decode(JsonUsers.self, from: data)
            asyncCallback(info?.items)
        }
    }

    func getITunesTrack(query: String, callback: @escaping ([ITunesTrack]?) -> Void) -> URLSessionTask {
        let asyncCallback = { (tracks: [ITunesTrack]?) in
            DispatchQueue.main.async {
                callback(tracks)
            }
        }
        return getJSON(url: Constants.urlITunesInfo, params: ["term": query]) { data in
            guard let data = data else {
                asyncCallback(nil)
                return
            }
            let info = try? JSONDecoder().decode(JsonTracks.self, from: data)
            asyncCallback(info?.results)
        }
    }
}
