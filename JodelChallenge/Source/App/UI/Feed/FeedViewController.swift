//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController: BaseCollectionViewController {
    
    // MARK: Public Instance Properties

    private var viewModel: FeedViewModel? { didSet { bindViewModel() } }

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        return refreshControl
    }()
    
    var pageNumber = 1
    var isWating = false

    // MARK: Overridden UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPhotos()
        registerNib()
    }

    // MARK: Private Instance Methods

    private func registerNib() {
        collectionView.register(UINib(nibName: FeedCell.nibName, bundle: nil), forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
    }

    private func setupView() {
        ProgressDialog.show(with: "Fetching photos...")
        viewModel = FeedViewModel(api: FlickrApi())
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }

    @objc  private func refreshView() {
        // clear the photos array and set pageNumber to 1 to reload view
        isWating = false
        pageNumber = 1
        viewModel?.photos.removeAll()
        collectionView.reloadData()
        fetchPhotos()
    }

    private func fetchPhotos() {
        viewModel?.fetchPhotos(pageNumber, delegate: self)
    }
    
    private func imageTapped(with imageUrl : URL) {
        guard let data = try? Data(contentsOf: imageUrl)  else { return }
        let image = UIImage(data: data)
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn) {
            self.view.addSubview(newImageView)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    @objc private func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.tabBarController?.tabBar.isHidden = false
        }) { _ in
            sender.view?.removeFromSuperview()
        }
    }
}

// MARK: Collectionview delegates, datasource and flowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell, let vm = viewModel else { return UICollectionViewCell() }
        cell.configure(with: vm.photos[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        if indexPath.row == vm.photos.count - 3 && !isWating {
            guard pageNumber != vm.totalNumberOfPages else { return }
            isWating = true
            pageNumber += 1
            fetchPhotos()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        let photoUrl = vm.photos[indexPath.row]
        if let url = photoUrl.getImagePath() {
            imageTapped(with: url)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size
        return CGSize(width: size.width, height: 280)
    }
}

// MARK: FeedDelegate

extension FeedViewController: FeedDelegate {

    func onFetchPhotos() {
        isWating = false
        DispatchQueue.main.async(execute: {
            ProgressDialog.hide()
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        })
    }
    
    func onError(_ message: String) {
        DispatchQueue.main.async(execute: {
            ProgressDialog.hide()
            self.refreshControl.endRefreshing()
            self.showAlertDialog(title: "Error", message: message)
        })
    }
}
