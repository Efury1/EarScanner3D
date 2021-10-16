//
//  AlbumViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 19/9/21.
//

import UIKit
import EasyPeasy
import SwiftyDropbox
import Photos


class AlbumViewController: UIViewController {
    var photo: UIImage? = nil
    var images: [UIImage] = []
    
    
    var albumItems: [AlbumModel] = []
    
    lazy var photoTable: UITableView = {
        let tv = UITableView()
        tv.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.id)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor(red: 9.0/255.0, green: 53.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        return tv
    }()
    
 
    override func loadView() {
        super.loadView()
        
        view.addSubview(photoTable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view Did load")
        photoTable.easy.layout(Edges())
//        photoTable.frame = view.bounds
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        loadData()
    }
 
    func loadData() {
        albumItems = AlbumModel.listAlbums()
        photoTable.reloadData()
    }
    
}


extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(albumItems.count)
        return albumItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.id, for: indexPath) as? AlbumCell {
            let row = indexPath.row
            
            let regex = AlbumModel.matches(for: "(?<=EarScanner3D: )(.*)(?= - )", in: albumItems[row].name)
            let setName = regex[0]
                        
            cell.photoView.image = UIImage(named: String(row))
            //cell.photoView.image = UIImage(named: items[row])
            cell.backgroundColor = UIColor(red: 9.0/255.0, green: 53.0/255.0, blue: 88.0/255.0, alpha: 1.0)
            //TODO: Put album string in text.text
            
            cell.text.text = setName
            cell.sendButton.tag = row
            
            
           
            
            cell.sendButton.addTarget(self, action: #selector(sendDidTap(button:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    

    //TO DO: Fetch photos from phone and match with name of table
    
///            LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY   LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY
    func fetchCustomAlbumPhotos(albumName: String)
    {
        
            self.images =  []
            
            var assetCollection = PHAssetCollection()
            var albumFound = Bool()
            var photoAssets = PHFetchResult<AnyObject>()
            let fetchOptions = PHFetchOptions()
            //get each album using the passed in name
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            //check if album found, if so set the variables
            if let firstObject = collection.firstObject{
                //found the album
                assetCollection = firstObject
                albumFound = true
            }
            else { albumFound = false }
            //if not found set the bool to say so
        
            //get the album object
            _ = collection.count
            photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
            //enumerate the objects photos
            let imageManager = PHCachingImageManager()
            photoAssets.enumerateObjects{(object: AnyObject!,
                count: Int,
                stop: UnsafeMutablePointer<ObjCBool>) in
                //if the photo exists/is valid
                if object is PHAsset{
                    let asset = object as! PHAsset
                    print("Inside  If object is PHAsset, This is number 1")
                    //set the image size to its innate size as stored in photos
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    print("size", asset.pixelWidth, asset.pixelHeight)
                    /* For faster performance, and maybe degraded image */
                    //set variables
                    let options = PHImageRequestOptions()
                    //high quality cause other options are WAY to low res, like 60*60
                    options.deliveryMode = .highQualityFormat
                    options.isSynchronous = true
                    //request for the image
                    imageManager.requestImage(for: asset,
                                                      targetSize: imageSize,
                                                      contentMode: .aspectFill,
                                                      options: options,
                                                      resultHandler: {
                                                        (image, info) -> Void in
                                                        self.photo = image!
                                                        /* The image is now available to us */
                                                        //add the image to the array
                                                        self.addImgToArray(uploadImage: self.photo!)
                                                        print("enum for image, This is number 2")

                    })

                }
            }
        }

        func addImgToArray(uploadImage:UIImage)
        {
            self.images.append(uploadImage)

        }
        
    ///            LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY   LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY

   
    @objc
    private func sendDidTap(button: Any?) {
        
//        if let button = button as? UIButton {
//        print("button", button.text.text)
//            print("Send tapped at \(button.tag)")
        
//        let clientBox = DropboxClientsManager.authorizedClient
//        if (clientBox == nil){
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write"], includeGrantedScopes: false)
        let client: () = DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: self,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
        
        

//        }

//            DropboxClientsManager.authorizeFromController(UIApplication.shared,
//                                                          controller: self,
//                                                          openURL: { (url: URL) -> Void in
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            })
        
        
     ///            LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY   LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY
        //if its stupid but it works it aint stupid
        //from the debug description, yes the debug description (string version of what you see if you print it off), of the passed button instance,
        //use regex to get the tag, which is set to the row of the button,
        let regex = AlbumModel.matches(for: "(?<=tag = )(.*)(?=;)", in: button.debugDescription)
        //as when row is zero , no tag exists, preset thevariable too zero and only if regex returns any results do you change it
        var setTag = "0"
        if (regex.count > 0){
            
            setTag = regex[0]
        }
        //use the row to get the album name
        let albumName = albumItems[Int(setTag) ?? 0].name
        
        print("Button",setTag )
        //use the function above this one, to set the 'images' array to contain all relevant image instances for the passed array name
        fetchCustomAlbumPhotos(albumName: albumName)

        print("images",self.images)
        //for each image in the array, construct a dropbox path using the users email, the albums name (includes date and time) and a counter that gives each photo a numerical name
        var photoCounter = 0
        for i in self.images{
                photoCounter += 1
                //+LoginViewController.Email+"/"+albumName+"/"+"photoCounter"
                print("path", "/Photos/"+LoginViewController.Email+"/1/1")
                let path = "/Photosets/"+LoginViewController.Email+"/"+albumName+"/"+String(photoCounter)
                //upload the image
                DropboxManager.shared.uploadImage(image: i, path: path)
            }
        }
    ///           LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY LIZZY       LIZZYLIZZY LIZZY   LIZZY   LIZZY       LIZZY   LIZZY   LIZZY   LIZZY   LIZZY
//    }
    
    
    //TO DO: let user create new folder
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //let path = "/Photos"
        //DropboxManager.shared.createFolder(path: path)
        //TODO: upload album
        //DropboxManager.shared.uploadImage(image: UIImage(named: "0")!, path: path)
      
    }*/
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates {
                AlbumModel.deleteAlbum(albumName: albumItems[indexPath.row].name, completion:  { status in
                    print(status)
                })
                albumItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            } completion: { _ in
                tableView.reloadData()
            }
        }
       
    }
    
}


