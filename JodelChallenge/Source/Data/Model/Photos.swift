import Foundation

struct Photos: Codable {
    let photos: PhotosClass
}

struct PhotosClass: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

struct Photo: Codable, PhotoURL {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    var asDictionary : [AnyHashable:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:AnyHashable?, value:Any) -> (AnyHashable, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
}

protocol PhotoURL {}

extension PhotoURL where Self == Photo {
    
    func getImagePath() -> URL? {
        let url = fk.photoURL(for: .small240, fromPhotoDictionary: self.asDictionary)
        return url
    }
    
}
