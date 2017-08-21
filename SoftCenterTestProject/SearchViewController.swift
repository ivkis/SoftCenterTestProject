//
//  SearchViewController.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 20/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    var tableView: UITableView!
    var searchBar: UISearchBar!

    var gitHubUsers: [GitHubUser]?

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white

        let segmentedControl = UISegmentedControl(items: ["iTunes", "GitHub"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)

        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultsCell.self, forCellReuseIdentifier: String(describing: SearchResultsCell.self))
        tableView.rowHeight = 80
        tableView.dataSource = self
        view.addSubview(tableView)

        view.addConstraints([
            segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    func loadData() {
        guard let query = searchBar.text else {
            return
        }
        API.shared.getGitHubUsers(query: query) { users in
            self.gitHubUsers = users
            self.tableView.reloadData()
            if users == nil {
                let alertController = UIAlertController(title: "Data not available", message: "Sorry, an error occurred. Update query.", preferredStyle: .alert)
                let alertActionUpdate = UIAlertAction(title: "Update", style: .default, handler: { action in
                    self.loadData()
                })
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(alertActionUpdate)
                alertController.addAction(alertActionCancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubUsers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsCell.self), for: indexPath) as! SearchResultsCell
        let user = gitHubUsers![indexPath.row]
        cell.configure(with: user, isEven: indexPath.row % 2 == 0)

        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
    }
}
