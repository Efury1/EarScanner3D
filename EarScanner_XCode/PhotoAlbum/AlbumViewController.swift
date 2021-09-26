//
//  AlbumViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 19/9/21.
//

import UIKit
import EasyPeasy
import Photos


class AlbumViewController: UIViewController {
    
    
    
    var names: [AlbumModel] = []
    
    var items: [Int] = []
    lazy var photoTable: UITableView = {
        let tv = UITableView()
        tv.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.id)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoTable)
        print("printing")
        names = listAlbums()
        if (names.count > 0){
            for i in 0...names.count-1{
                print("i", i)
                items.append(i)
            }
        }
        photoTable.easy.layout(Top(), Left(), Right(), Bottom())
    }
    
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.id, for: indexPath) as? AlbumCell {
            let row = indexPath.row
     
            let range = NSRange(location: 0, length: names[row].name.utf16.count)
            let regex = matches(for: "(?<=EarScanner3D: )(.*)(?= - )", in: names[row].name)
            let regex2 = matches(for: "(?<= - ).*", in: names[row].name)
            let setName = regex[0]
            
            let setDate =  regex2[0]
                
            cell.photoView.image = UIImage(named: String(items[row]))
            
            cell.text.text = setName
            cell.sendButton.tag = row
            cell.sendButton.addTarget(self, action: #selector(sendDidTap(button:)), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
    /*James can add in code to send*/
    @objc
    private func sendDidTap(button: Any?) {
        if let button = button as? UIButton {
            print("Send tapped at \(button.tag)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates {
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
                self.deleteAlbum(albumName: names[indexPath.row].name)
                
            } completion: { _ in
                tableView.reloadData()
            }
            
        }
    }
    func deleteAlbum(albumName: String){
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)


        // check if album is available
        if album.firstObject != nil {

            // request to delete album
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.deleteAssetCollections(album)
        }, completionHandler: { (success, error) in
            if success {
                print(" \(albumName) removed succesfully")
            } else if error != nil {
                print("request failed. please try again")
            }
        })
        }else{
            print("requested album \(albumName) not found in photos")
        }
    }
    //check every album to see if it has the name 'EarScanner3D:' in it, if it does we will try to show it as one of the rows
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
    
    func listAlbums() -> [AlbumModel] {
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
            print("album",item.name)
            
            if (item.name.contains("EarScanner3D:")){
                names.append(item)
                
            }
        }
        return names
    }
    func matches(for regex: String, in text: String) -> [String] {

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
}
