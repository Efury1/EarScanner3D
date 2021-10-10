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




//TODO: Delete should delete from phone as well as application
//TODO: Do String matching to link cell to album on phone

class AlbumViewController: UIViewController {
    
    //TODO: ensure that the tables are correctly loaded
    override func loadView() {
        
    }
    
    var items: [String] = ["0", "1", "2", "3"]
    var names: [MyAwesomeAlbum] = []
    //var albumName: [MyAwesomeAlbum] = []
    
    lazy var photoTable: UITableView = {
        //TODO: Add iteams and album name to album
        //items = []
        //albumName = []
        let tv = UITableView()
        tv.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.id)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor(red: 9.0/255.0, green: 53.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(photoTable)

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
            //cell.photoView.image = UIImage(named: items[row])
            cell.backgroundColor = UIColor(red: 9.0/255.0, green: 53.0/255.0, blue: 88.0/255.0, alpha: 1.0)
            //TODO: Put album string in text.text
            
            cell.text.text = "Photoset \(row + 1)"
            cell.sendButton.tag = row
            cell.sendButton.addTarget(self, action: #selector(sendDidTap(button:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    //TO DO: Fetch photos from phone and match with name of table
    func fetchCustomAlbumPhotos()
    {
        
    }

   
    @objc
    private func sendDidTap(button: Any?) {
        if let button = button as? UIButton {
            print("Send tapped at \(button.tag)")
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write"], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: self,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
//            DropboxClientsManager.authorizeFromController(UIApplication.shared,
//                                                          controller: self,
//                                                          openURL: { (url: URL) -> Void in
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            })
        }
    }
    
    //TO DO: let user create new folder
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let path = "/Photos"
        //DropboxManager.shared.createFolder(path: path)
        DropboxManager.shared.uploadImage(image: UIImage(named: "0")!, path: path)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates {
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            } completion: { _ in
                tableView.reloadData()
            }
        }
       
    }
    
}


