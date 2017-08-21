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

    var githubDataSource: GitHubDataSource!

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white

        let segmentedControl = UISegmentedControl(items: ["iTunes", "GitHub"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
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

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        githubDataSource = GitHubDataSource(tableView: tableView)
        tableView.dataSource = githubDataSource
        searchBar.delegate = githubDataSource
    }
}
