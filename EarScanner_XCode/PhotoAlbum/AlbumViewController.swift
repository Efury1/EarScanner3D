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
                //TODO: Make sure it recognised the Photos album
                let path = "/Photos/"
                //TODO: Send through phone album
                DropboxManager.shared.uploadImage(image: UIImage(named: "0")!, path: path)
            
//            DropboxClientsManager.authorizeFromController(UIApplication.shared,
//                                                          controller: self,
//                                                          openURL: { (url: URL) -> Void in
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            })
        }
    }
    
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


