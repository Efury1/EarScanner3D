//
//  AlbumModel.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 10/10/21.
//

import Foundation
import Photos

class AlbumModel {
    let name:String
    let count:Int
    let collection:PHAssetCollection
    init(name:String, count:Int, collection:PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
    }
}

extension AlbumModel {
    static func listAlbums() -> [AlbumModel] {
        var album:[AlbumModel] = [AlbumModel]()
        
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        userAlbums.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
                album.append(newAlbum)
            }
        }
        var names: [AlbumModel] = []
        for item in album {
            
            if (item.name.contains("EarScanner3D:")){
//                print("album",item.name)
                names.append(item)
            }
        }
        return names
    }
    
    static func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func deleteAlbum(albumName: String, completion: @escaping (Bool) -> Void) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        var success2 = false
        
        // check if album is available
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            if album.firstObject != nil {
                
                // request to delete album
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.deleteAssetCollections(album)
                }, completionHandler: { (success, error) in
                    if success {
                        print(" \(albumName) removed succesfully")
                        success2 = true
                        group.leave()
                        
                    } else if error != nil {
                        print("request failed. please try again")
                        group.leave()
                    }
                })
            } else {
                print("requested album \(albumName) not found in photos")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(success2)
            print("refreshed", success2)
        }
    }
}
