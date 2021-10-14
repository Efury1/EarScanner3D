//
//  Step1ViewController.swift
//  EarScanner_XCode
//
//  Created by Isabella Turco on 17/9/21.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class Step1: UIViewController, AVPlayerViewControllerDelegate {
    let player = AVPlayer(url:  Bundle.main.url(forResource: "Step-1-front", withExtension: "mp4")!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideoInView()
    }

    func playVideoInView() {
        guard let path = Bundle.main.url(forResource: "Step-1-front", withExtension: "mp4") else {
            return
        }
        print("self: ",self)
        
        let screenRect = UIScreen.main.bounds
        //get screen width
        let screenWidth = screenRect.size.width
        //get screen height
        let screenHeight = screenRect.size.height
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: 300*1.2, height: 170*1.2)
        //playerViewController.center

        player.play()
        
        playerViewController.view.center = CGPoint(x: screenWidth/2,
                                                   y: 260+(screenHeight/14) )
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
