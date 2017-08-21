//
//  GitHubDataSource.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class GitHubDataSource: NSObject {

    var gitHubUsers: [GitHubUser]?
    var tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func loadData(query: String?) {
        guard let query = query else {
            return
        }
        API.shared.getGitHubUsers(query: query) { users in
            self.gitHubUsers = users
            self.tableView.reloadData()
            if users == nil {
                let alertController = UIAlertController(title: "Data not available", message: "Sorry, an error occurred. Update query.", preferredStyle: .alert)
                let alertActionUpdate = UIAlertAction(title: "Update", style: .default, handler: { action in
                    self.loadData(query: query)
                })
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(alertActionUpdate)
                alertController.addAction(alertActionCancel)
//                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


extension GitHubDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubUsers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsCell.self), for: indexPath) as! SearchResultsCell
        let user = gitHubUsers![indexPath.row]
        cell.configure(with: user, isRight: indexPath.row % 2 == 0)

        return cell
    }
}


extension GitHubDataSource: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(query: searchText)
    }
}
