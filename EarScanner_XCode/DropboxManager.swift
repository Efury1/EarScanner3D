//
//  DropboxManager.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 8/10/21.
//

import Foundation
import SwiftyDropbox
import UIKit


//Manually retreive access token?
class DropboxManager {
    // Reference after programmatic auth flow
    //private won't be available outside class
//    private let client: DropboxClient?
    //singletion, available at class level because it's static
    static let shared = DropboxManager()
    
    func setupDropbox() {
        // TODO: - Keychain when uploading to cloud
        DropboxClientsManager.setupWithAppKey("ee1lc87gd8fnt0q")
    }
    
    /*Upload request*/
    func uploadImage(image: UIImage, path: String) {
        
        guard let client = DropboxClientsManager.authorizedClient, let fileData = image.pngData() else {
            print("Failed to obtain client or image data")
            return
        }
        let _ = client.files.upload(path: path, input: fileData)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
            }

        // in case you want to cancel the request
//            request.cancel()

    }
    
    func createFolder(path clientPath: String) {
        
        guard let client = DropboxClientsManager.authorizedClient else {
            print("Client nil")
            return
        }
        client.files.createFolderV2(path: clientPath).response {
            response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }

    }
}
