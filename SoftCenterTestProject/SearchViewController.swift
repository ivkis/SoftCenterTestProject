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
    var segmentedControl: UISegmentedControl!
    var searchBar: UISearchBar!

    var githubDataSource: GitHubDataSource!
    var itunesDataSource: ITunesDataSource!

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white

        segmentedControl = UISegmentedControl(items: ["iTunes", "GitHub"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(switchSegmentedControl), for: .valueChanged)
        view.addSubview(segmentedControl)

        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultsCell.self, forCellReuseIdentifier: String(describing: SearchResultsCell.self))
        tableView.rowHeight = 80
        view.addSubview(tableView)

        view.addConstraints([
            segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        segmentedControl.selectedSegmentIndex = 0
        switchSegmentedControl()
    }

    func switchSegmentedControl() {
        searchBar.text = ""
        if segmentedControl.selectedSegmentIndex == 0 {
            itunesDataSource = ITunesDataSource(tableView: tableView)
            itunesDataSource.delegate = self
            tableView.dataSource = itunesDataSource
            searchBar.delegate = itunesDataSource
        } else {
            githubDataSource = GitHubDataSource(tableView: tableView)
            githubDataSource.delegate = self
            tableView.dataSource = githubDataSource
            searchBar.delegate = githubDataSource
        }
        tableView.reloadData()
    }
}


extension SearchViewController: DataSourceDelegate {
    func dataSourceDidFailWithError(_ dataSource: AnyObject) {
        let alertController = UIAlertController(title: "Data not available", message: "Sorry, an error occurred. Try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
