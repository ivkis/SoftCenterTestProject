//
//  ITunesDataSource.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class ITunesDataSource: NSObject {

    weak var dataLoadTask: URLSessionTask?
    var iTunesTracks: [ITunesTrack]?
    var tableView: UITableView
    weak var delegate: DataSourceDelegate?
    weak var cellDelegate: SearchResultsCellDelegate?
    var query = ""

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func loadData() {
        dataLoadTask?.cancel()
        dataLoadTask = API.shared.getITunesTrack(query: query) { tracks in
            self.iTunesTracks = tracks
            self.tableView.reloadData()
            if tracks == nil {
                self.delegate?.dataSourceDidFailWithError(self)
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
        cell.delegate = cellDelegate
        return cell
    }
}


extension ITunesDataSource: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
        loadData()
    }
}
