//
//  DropboxManager.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 8/10/21.
//

import Foundation
import SwiftyDropbox
import UIKit

final class DropboxManager {
    static let shared = DropboxManager()
    
    func setupDropbox() {
        // TODO: - Keychain when uploading to cloud
        DropboxClientsManager.setupWithAppKey("p43i7ap4i2p6s2p")
    }
    
    
}
