import Foundation

protocol FeedDelegate {
    func onFetchPhotos()
    func onError(message: String)
}
class FeedViewModel {

    var photos : [URL] = []
    var api: FlickrApiProtocol?

    init(api: FlickrApiProtocol) {
        self.api = api
    }

    func fetchPhotos(delegate: FeedDelegate) {
        api?.fetchPhotos { [weak self] (responsePhotos, error) in
            if let responsePhotos = responsePhotos {
                self?.photos = responsePhotos
                delegate.onFetchPhotos()
            } else {
                delegate.onError(message: error?.localizedDescription ?? "An error occured")
            }
        }
    }
}
