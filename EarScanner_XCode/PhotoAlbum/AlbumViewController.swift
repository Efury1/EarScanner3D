//
//  AlbumViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 19/9/21.
//

import UIKit
import EasyPeasy
import OneDriveSDK

class AlbumViewController: UIViewController {
    
    
    var items: [String] = ["0", "1", "2", "3"]
    
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
            cell.photoView.image = UIImage(named: items[row])
            cell.text.text = "Photoset \(row + 1)"
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
            } completion: { _ in
                tableView.reloadData()
            }

        }
    }
}
