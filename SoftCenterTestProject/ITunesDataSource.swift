//
//  ITunesDataSource.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class ITunesDataSource: NSObject {

    var iTunesTracks: [ITunesTrack]?
    var tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func loadData(query: String?) {
        guard let query = query else {
            return
        }
        API.shared.getITunesTrack(query: query) { tracks in
            self.iTunesTracks = tracks
            self.tableView.reloadData()
            if tracks == nil {
                print("Error on server")
            }
        }
    }
}


extension ITunesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iTunesTracks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsCell.self), for: indexPath) as! SearchResultsCell
        let track = iTunesTracks![indexPath.row]
        cell.configure(with: track, isRight: indexPath.row % 2 == 0)

        return cell
    }
}


extension ITunesDataSource: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(query: searchText)
    }
}
