//
//  PhotoCell.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {
    static let reuseIdentifier = "photo.cellIdentifier"

    private var photoThumbnailView: UIImageView!
    private var titleLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        photoThumbnailView = UIImageView()
        photoThumbnailView.backgroundColor = .lightGray

        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        photoThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoThumbnailView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        photoThumbnailView
            .top(8)
            .bottom(8)
            .leading(16)
            .height(equalTo: photoThumbnailView.widthAnchor)
            .trailing(16, to: titleLabel.leadingAnchor)

        titleLabel
            .top(8)
            .trailing(16)
    }

    func setup(with viewModel: PhotoCellViewModel) {
        titleLabel.text = viewModel.title
        photoThumbnailView.image = viewModel.image
    }
}
