//
//  ViewController.swift
//  EarScanner_XCode
//
//  Created by James Noye on 30/7/21.
//
import AVFoundation
import UIKit
import Foundation
//test
import EasyPeasy
import AYStepperView
import SwiftUI


class ViewController: UIViewController {
    
    @IBOutlet var imageTake: UIImage!
    @IBOutlet var imageTakePast: UIImage!
    var Retake = true
    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!

    //capture session
    var session: AVCaptureSession?
    //Photo Output
    let output = AVCapturePhotoOutput()
    //Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    //Shutter Button
    
//    z
    let easy = SetUpViewController();
    //Lizzy 1
    //Create the views of the four bars (images)
      
//    var imageView : UIImageView //maybe change the frame dimensions
//    imageView  = UIImageView(frame:CGRectMake(10, 50, 100, 300));
//    imageView.image = UIImage(named:"Bar1.jpg")
    

    var currentProgress = 0
    let lineHeight: CGFloat = 5
    
    var containerWidth: CGFloat {
        self.view.frame.size.width * 0.95
    }
    var containerHeight: CGFloat {
        self.containerWidth/7
    }
    var viewSize: CGFloat {
        self.containerWidth/9
    }
    var lineWidth: CGFloat {
        self.containerWidth/8
    }
    var padding: CGFloat {
        self.containerWidth/45
    }
    
    let containerView = UIView()
    
    var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let line2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let line3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    private func addViews(views: [UIView]) {
        for view in views {
            containerView.addSubview(view)
        }
    }

   /*Capture button*/
    
    public let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.backgroundColor = UIColor.lightGray.cgColor
        /*Counter */
        var counter = 30
        for i in 0..<counter {
            // Do stuff...
            let newValue = counter + 1
            button.setTitle("\(newValue)",for: .normal)
        }
        
        //button.setTitle("\(items)",for: .normal)
        return button
    }()
    //the button to retake the photo
    private let RetakeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "gobackward", withConfiguration: largeTitle), for: .normal)
        //button.setTitle("Retake", for: .normal)
        
        return button
    }()
    //button to move to the next photo
    private let NextPhotoButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        button.setTitle("Next Photo", for: .normal)
        
        return button
    }()
    
    private let HelpButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        //let black = UIImage.SymbolConfiguration(weight: .black)
        //let combined = largeTitle.applying(black)
        button.setImage(UIImage(systemName: "questionmark", withConfiguration: largeTitle), for: .normal)
        
        //button.setTitle("Help", for: .normal)
        return button
    }()



    //if view has loaded make the background black (for simulator)
    //add the camera preview sub layer
    //and check permissions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
 
        
        
        
        checkCameraPermissions()
//        let gridView = GridView()

        //Get screen size object
        let screenRect = UIScreen.main.bounds
        //get screen width
        let screenWidth = screenRect.size.width
        //get screen height
        let screenHeight = screenRect.size.height
        MyVariables.screenWidth = screenWidth;
        MyVariables.screenHeight = screenHeight;

       
    }
    //create the preview layer frames and place the buttons on them
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds

        
        HelpButton.center = CGPoint(x: MyVariables.screenWidth - (MyVariables.screenWidth*0.85),
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*0.145) )
        NextPhotoButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
                                         y: MyVariables.screenHeight - (MyVariables.screenHeight*0.3) )
       
        shutterButton.center = CGPoint(x: (MyVariables.screenWidth/2) ,
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*0.19) )
        
        RetakeButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
                                         y: MyVariables.screenHeight - (MyVariables.screenHeight*0.145) )
    }
    private func checkCameraPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        
        case .notDetermined:
            //request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else{
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera(){
        let session = AVCaptureSession()
        addGridView()
        
      

        if let device = AVCaptureDevice.default(for: .video){
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                //create a temperature element
                let temp = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues.init(temperature: 3000, tint: 0)
                //convert the temperature element into white balance gains
                let tempgains = device.deviceWhiteBalanceGains(for: temp)
                //define a time element of 1/60 seconds
                let exposureTime = CMTimeMake(value: 1, timescale: 60)
                
//                var Gains = AVCaptureDevice.WhiteBalanceGains.init(redGain: 4, greenGain: 2.82, blueGain: 1.68)
                //lock the white balance
                try device.lockForConfiguration() //add a catch
                //set the white balance to the gains
                device.setWhiteBalanceModeLocked(with: tempgains, completionHandler: nil)
                //set exposure to the defined time element and iso to 200
                device.setExposureModeCustom(duration: exposureTime, iso: 200, completionHandler: nil)
                //unlock
                device.unlockForConfiguration()
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch{
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        //increment counter on button press
        MyVariables.counter += 1;
            
        
    }

    
}



extension ViewController: AVCapturePhotoCaptureDelegate {
 
    struct MyVariables {
        static var yourVariable = false
        static var bottomPinkBar = UIView()
        
        static var screenWidth = CGFloat(0.1);
        static var screenHeight = CGFloat(0.1);
        //counter for button and progress bar
        static var counter = 0;

    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else{
            return
        }
        
        
//        func writeToPhotoAlbum(image: UIImage) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
        
        
        let image = UIImage(data: data)
        
//        let grid: UIView = {
//            let grid = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//
//            return grid
//        }()
        imageView =  UIImageView(image: image)
        
        //Maybe Remove
        session?.stopRunning()
        //Does it restart?
    
        imageView.contentMode = .scaleAspectFill
        
//        writeToPhotoAlbum(image: image!)
        //remove ad re-add elements
        
        shutterButton.removeFromSuperview()
        HelpButton.removeFromSuperview()
        MyVariables.bottomPinkBar.removeFromSuperview()
        NextPhotoButton.removeFromSuperview()
        RetakeButton.removeFromSuperview()
        
        imageView.frame = view.bounds
        
        view.addSubview(imageView)

       
        view.addSubview(MyVariables.bottomPinkBar)
        view.addSubview(shutterButton)
        view.addSubview(RetakeButton)
        view.addSubview(HelpButton)
        //view.addSubview(bottomPinkBar)
        view.addSubview(NextPhotoButton)
        let seconds2 = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
            
            
            
         

        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {
                return
            }
            switch self.currentProgress {
            case 0:
                self.view1.alpha = 1
            case 1:
                self.view2.alpha = 1
                self.line1.alpha = 1
            case 2:
                self.view3.alpha = 1
                self.line2.alpha = 1
            case 3:
                self.view4.alpha = 1
                self.line3.alpha = 1
            default:
                self.view1.alpha = 0.5
                self.view2.alpha = 0.5
                self.line1.alpha = 0.5
                self.view3.alpha = 0.5
                self.line2.alpha = 0.5
                self.view4.alpha = 0.5
                self.line3.alpha = 0.5
            }
            if self.currentProgress > 3 {
                self.currentProgress = 0
            } else {
                self.currentProgress += 1
            }
        }
        }

        imageTakePast = imageTake
        
        
        imageTake = image
        if (Retake != true){
            MyAwesomeAlbum.shared.albumName = "RemovalTest"
            
            MyAwesomeAlbum.shared.save(image: self.imageTakePast)
        }
        Retake = false
        NextPhotoButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        
        RetakeButton.addTarget(self, action: #selector(retake), for: .touchUpInside)
        
        let seconds = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            
            
            self.session?.startRunning()
            self.imageView.removeFromSuperview()
            

        }

        
        
        
        
    }
    @objc private func savePhoto() {
//        UIImageWriteToSavedPhotosAlbum(imageTake, nil, nil, nil)
       
    }

    @objc private func retake() {
        Retake = true;
        session?.startRunning()
        imageView.removeFromSuperview()
        
    }
    public func addGridView() {
        // cameraView is your view where you want to show the grid view
        let horizontalMargin = -10
        let verticalMargin = -10
        
        
        
        let gridView = GridView()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //make and place rectangle
        /*let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(screenHeight-(screenHeight*0.19)), width:CGFloat(screenWidth), height:CGFloat(screenHeight*0.1))*/
     let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(screenHeight-(screenHeight*0.20)), width:CGFloat(screenWidth), height:CGFloat(screenHeight*0.1))
        
              
              // Create a UIView object which use above CGRect object.
        let bottomPinkBar = UIView(frame: rectFrame)
//        bottomPinkBar.center = CGPoint(x: CGFloat(screenWidth/2),
//                                   y: CGFloat(screenHeight-(screenHeight*0.05)))
              // Set UIView background color.
        
                bottomPinkBar.backgroundColor = UIColor(rgb: 0xA87F8B)
        
        MyVariables.bottomPinkBar = bottomPinkBar
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

        gridView.translatesAutoresizingMaskIntoConstraints = false
        //add image based upon what number counter is at
        view.addSubview(gridView)
        //bottom pink bar
        view.addSubview(bottomPinkBar)
        //main circle button
        view.addSubview(shutterButton)
        //retake button
        view.addSubview(RetakeButton)
        //help
        view.addSubview(HelpButton)
        
        
        containerView.easy.layout(Top(padding).to(view.safeAreaLayoutGuide, .top), CenterX(), Width(containerWidth), Height(containerHeight))
        
        
        addViews(views: [view1, view2, view3, view4])
        addViews(views: [line1, line2, line3])
        
        view1.easy.layout(CenterY(), Left(padding).to(containerView, .left), Size(viewSize))
        view1.rounded(radius: viewSize/2)
        
        line1.easy.layout(CenterY(), Left(padding).to(view1, .right), Height(lineHeight), Width(lineWidth))

        line1.rounded(radius: lineHeight/2)
        
        view2.easy.layout(CenterY(), Left(padding).to(line1, .right), Size(viewSize))
        view2.rounded(radius: viewSize/2)
        
        line2.easy.layout(CenterY(), Left(padding).to(view2, .right), Height(lineHeight), Width(lineWidth))
        line2.rounded(radius: lineHeight/2)
        
        view3.easy.layout(CenterY(), Left(padding).to(line2, .right), Size(viewSize))
        view3.rounded(radius: viewSize/2)
        
        line3.easy.layout(CenterY(), Left(padding).to(view3, .right), Height(lineHeight), Width(lineWidth))
        line3.rounded(radius: lineHeight/2)
        
        view4.easy.layout(CenterY(), Left(padding).to(line3, .right), Size(viewSize))
        view4.rounded(radius: viewSize/2)
        view.addSubview(containerView)
    
        //view.addSubview(bottomPinkBar)
        view.addSubview(NextPhotoButton)
        
        gridView.backgroundColor = UIColor.clear
        gridView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(horizontalMargin)).isActive = true
        gridView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(-1 * horizontalMargin)).isActive = true
        gridView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(verticalMargin)).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-1 * verticalMargin)).isActive = true
        
        //set up a global counter variable (done)
        //ever
    }
}




extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
