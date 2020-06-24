//
//  PhotosListViewController.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

final class PhotosListViewController: UITableViewController {
    var viewModel: PhotosListViewModel!

    private let queue = DispatchQueue(label: "images.queue")

    private enum Section {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, PhotoCellViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()

        makeDataSource()
        setupBindings()
    }

    private func makeDataSource() {
        let cellIdentifier = "photo.cellIdentifier"

        dataSource = .init(tableView: tableView, cellProvider: { (tableView, indexPath, photoItem) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier,
                for: indexPath) as? PhotoCell else {
                    fatalError("Couldn't dequeue a cell")
            }
            
            cell.setup(with: photoItem)

            photoItem.loadImage(completion: { [weak self] in
                guard let self = self else { return }
                var updatedSnapshot = self.dataSource.snapshot()
                self.queue.async {                    
                    updatedSnapshot.reloadItems([photoItem])
                    self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                }
            })
            return cell
        })

        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 0
        tableView.register(PhotoCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    private func setupBindings() {
        viewModel.output = PhotosList.Output(
            photoItems: { [weak self] items in
                guard let self = self else { return }
                self.queue.async {
                    var initialSnapshot = NSDiffableDataSourceSnapshot<Section, PhotoCellViewModel>()
                    initialSnapshot.appendSections([.main])
                    initialSnapshot.appendItems(items)

                    self.dataSource.apply(initialSnapshot, animatingDifferences: true)
                }
            },
            error: { [weak self] in
                self?.displayError(with: $0)
            })
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel.photoSelected(item)
    }
}
