//
//  PhotoDetailsViewController.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

final class PhotoDetailsViewController: UIViewController {
    var viewModel: PhotoDetailsViewModel!

    private var photoView: UIImageView!
    private var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupUI()
        setupBindings()
        viewModel.loadPhoto()
    }

    private func setupUI() {
        photoView = UIImageView()
        photoView.backgroundColor = .lightGray

        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        photoView
            .top(16, to: view.safeAreaLayoutGuide.topAnchor)
            .leading(16)
            .centerX()
            .height(equalTo: photoView.widthAnchor)
            .bottom(20, to: titleLabel.topAnchor)

        titleLabel
            .leading(20)
            .centerX()
    }

    private func setupBindings() {
        viewModel.output = PhotoDetails.Output(
            photoTitle: { [weak self] in
                self?.titleLabel.text = $0
            },
            photoImage: { [weak self] in
                self?.photoView.image = $0
            },
            error: { [weak self] in
                self?.displayError(with: $0)
            })
    }
}

