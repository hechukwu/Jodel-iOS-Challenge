import Foundation

protocol FeedDelegate {
    func onFetchPhotos()
    func onError(_ message: String)
}

class FeedViewModel {

    // MARK: Internal Properties

    var photos : [Photo] = []
    var api: FlickrApiProtocol?

    // MARK: class Initializers

    init(api: FlickrApiProtocol) {
        self.photos.removeAll()
        self.api = api
    }

    // MARK: Internal Methods

    func fetchPhotos(_ page: Int, delegate: FeedDelegate) {
        api?.fetchPhotos(page) { [weak self] (responsePhotos, error) in
            if let responsePhotos = responsePhotos {
                self?.photos += responsePhotos
                delegate.onFetchPhotos()
            } else {
                delegate.onError(error?.localizedDescription ?? "An error occured")
            }
        }
    }
}
