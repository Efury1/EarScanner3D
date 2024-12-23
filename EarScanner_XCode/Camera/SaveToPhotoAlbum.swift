import Photos
import UIKit

class MyAwesomeAlbum: NSObject {
    var albumName = ""
    
    
    
    
    // Prints "Sep 9, 2014, 4:30 AM"
    static let shared = MyAwesomeAlbum()
    
    private var assetCollection: PHAssetCollection!
    public var datetime = ""
    public var dateCreated = false
    private override init() {
        super.init()
        let now = Date()
        
//        let formatter = DateFormatter()
//        formatter.dateStyle = .full
//        formatter.timeStyle = .full
//        self.albumName = MainViewController.GlobalPhotosetName
//        datetime = formatter.string(from: now)
//        print("time", datetime)
//        self.albumName = "EarScanner3D: " + self.albumName+" - " + datetime
//
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }

    private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool) -> Void)) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.checkAuthorizationWithHandler(completion: completion)
            })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
            
        }
        else {
            completion(false)
        }
    }
    
    private func createAlbumIfNeeded(completion: @escaping ((_ success: Bool) -> Void)) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            self.assetCollection = assetCollection
            completion(true)
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)   // create an asset collection with the album name
                
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(true)
                } else {
                    // Unable to create album
                    completion(false)
                }
            }
        }
        
       
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        //if first instance of the album, recreate the time and date
        if (ViewController.photoCount == 0 && ViewController.SecondEar == false){
                    let now = Date()
            dateCreated = true
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
                    datetime = formatter.string(from: now)
                    print("time", datetime)
        
        }

        self.albumName = MainViewController.GlobalPhotosetName

        
        self.albumName = "EarScanner3D: " + self.albumName+" - " + datetime
        
        print("name",self.albumName)
    
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
        
    }
    
    func save(image: UIImage) {
        self.checkAuthorizationWithHandler { (success) in
            if success, self.assetCollection != nil {
                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                        let enumeration: NSArray = [assetPlaceHolder!]
                        print("NSArray",enumeration)
                        albumChangeRequest.addAssets(enumeration)
                        //albumChangeRequest.removeAssets(enumeration)
                    }
                    
                }, completionHandler: { (success, error) in
                    if success {
                        print("Successfully saved image to Camera Roll.")
                    } else {
                        print("Error writing to image library: \(error!.localizedDescription)")
                    }
                })
                
            }
        }
    }


    func saveMovieToLibrary(movieURL: URL) {
        
        self.checkAuthorizationWithHandler { (success) in
            if success, self.assetCollection != nil {
                
                PHPhotoLibrary.shared().performChanges({
                    
                    if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieURL) {
                        let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                            let enumeration: NSArray = [assetPlaceHolder!]
                            albumChangeRequest.addAssets(enumeration)
                        }
                        
                    }
                    
                }, completionHandler:  { (success, error) in
                    if success {
                        print("Successfully saved video to Camera Roll.")
                    } else {
                        print("Error writing to movie library: \(error!.localizedDescription)")
                    }
                })
                
                
            }
        }
        
    }
    
    
    
}
