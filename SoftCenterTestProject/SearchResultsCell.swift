//
//  SearchResultsCell.swift
//  SoftCenterTestProject
//
//  Created by IvanLazarev on 21/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class SearchResultsCell: UITableViewCell {
    fileprivate var contentConstraints: [NSLayoutConstraint]?
    fileprivate weak var imageLoadTask: URLSessionTask?
    var photoImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSearchResultsCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSearchResultsCell()
    }

    func setupSearchResultsCell() {
        photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.addConstraint(photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 1))
        photoImageView.backgroundColor = .lightGray
        self.contentView.addSubview(photoImageView)

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        self.contentView.addSubview(titleLabel)

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 2
        self.contentView.addSubview(subtitleLabel)
    }

    func configure(with gitHubUser: GitHubUser, isEven: Bool) {
        titleLabel.text = gitHubUser.login
        subtitleLabel.text = gitHubUser.url
        photoImageView.image = nil

        imageLoadTask?.cancel()
        if !gitHubUser.avatarUrl.isEmpty {
            imageLoadTask = API.shared.getImageFrom(url: gitHubUser.avatarUrl) { image in
                self.photoImageView.image = image
            }
        }
        setEvenUI(isEven)
    }

    func setEvenUI(_ isEven: Bool) {
        contentConstraints?.forEach({ $0.isActive = false })
        if isEven {
            contentConstraints = [
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

                titleLabel.trailingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: -10),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                subtitleLabel.trailingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: -10),
                subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            ]
            contentView.addConstraints(contentConstraints!)
            titleLabel.textAlignment = .right
            subtitleLabel.textAlignment = .right
        } else {
            contentConstraints = [
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

                titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                subtitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
                subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ]
            contentView.addConstraints(contentConstraints!)
            titleLabel.textAlignment = .left
            subtitleLabel.textAlignment = .left
            
        }
    }
}
