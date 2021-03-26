//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: FeedViewModel?

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        ProgressDialog.show(with: "Fetching photos...")
        viewModel = FeedViewModel(api: FlickrApi())
        viewModel?.fetchPhotos(delegate: self)
        registerNib()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell, let vm = viewModel else { return UICollectionViewCell() }
        cell.configure(with: vm.photos[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size
        return CGSize(width: size.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        let photoUrl = vm.photos[indexPath.row]
        imageTapped(with: photoUrl)
    }

    private func registerNib() {
        collectionView.register(UINib(nibName: FeedCell.nibName, bundle: nil), forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
    }

    private func setupView() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshView() {
        viewModel?.fetchPhotos(delegate: self)
    }
    
    func imageTapped(with imageUrl : URL) {
        guard let data = try? Data(contentsOf: imageUrl)  else { return }
        let image = UIImage(data: data)
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

extension FeedViewController: FeedDelegate {

    func onFetchPhotos() {
        DispatchQueue.main.async(execute: {
            ProgressDialog.hide()
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        })
    }
    
    func onError(message: String) {
        DispatchQueue.main.async(execute: {
            ProgressDialog.hide()
            self.refreshControl.endRefreshing()
            self.showAlertDialog(title: "Error", message: message)
        })
    }
}
