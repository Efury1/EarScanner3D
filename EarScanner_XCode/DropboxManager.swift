//
//  DropboxManager.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 8/10/21.
//

import Foundation
import SwiftyDropbox
import UIKit


//class to help mannage dropbox access
class DropboxManager {
    // Reference after programmatic auth flow
    //private won't be available outside class
//    private let client: DropboxClient?
    //singletion, available at class level because it's static
    static let shared = DropboxManager()
    //setup the dropbox using the app key registered with the account
    func setupDropbox() {
        // TODO: - Keychain when uploading to cloud
        DropboxClientsManager.setupWithAppKey("p43i7ap4i2p6s2p")
    }
    
    /*Upload request*/
    public func uploadImage(image: UIImage, path: String) {
        //verify the user has logged in, and the file data is present
        guard let client = DropboxClientsManager.authorizedClient, let fileData = image.pngData() else {
            print("Failed to obtain client or image data")
            return
        }
        //
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
