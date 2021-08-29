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


class ViewController: UIViewController {
    @IBOutlet weak var imageTake: UIImage!
    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!

    //capture session
    var session: AVCaptureSession?
    //Photo Output
    let output = AVCapturePhotoOutput()
    //Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    //Shutter Button
    public let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    //the button to retake the photo
    private let RetakeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        button.setTitle("Retake", for: .normal)
        
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
        button.setTitle("Help", for: .normal)
        
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
        let gridView = GridView()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        MyVariables.screenWidth = screenWidth;
        MyVariables.screenHeight = screenHeight
        ;

    }
    //create the preview layer frames and place the buttons on them
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        
        RetakeButton.center = CGPoint(x: MyVariables.screenWidth - (MyVariables.screenWidth*0.85),
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*0.145) )
        NextPhotoButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
                                         y: MyVariables.screenHeight - (MyVariables.screenHeight*0.3) )
       
        shutterButton.center = CGPoint(x: (MyVariables.screenWidth/2) ,
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*0.19) )
        HelpButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
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
    }

    
}



extension ViewController: AVCapturePhotoCaptureDelegate {
 
    struct MyVariables {
        static var yourVariable = false
        static var greenview = UIView()
        static var screenWidth = CGFloat(0.1);
        static var screenHeight = CGFloat(0.1);
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
        MyVariables.greenview.removeFromSuperview()
        NextPhotoButton.removeFromSuperview()
        RetakeButton.removeFromSuperview()
        
        imageView.frame = view.bounds
        
        view.addSubview(imageView)

       
        view.addSubview(MyVariables.greenview)
        view.addSubview(shutterButton)
        view.addSubview(RetakeButton)
        view.addSubview(HelpButton)
        //view.addSubview(greenView)
        view.addSubview(NextPhotoButton)
        
        
        
        imageTake = image
        NextPhotoButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        
        RetakeButton.addTarget(self, action: #selector(retake), for: .touchUpInside)
        
        
        
        
        
        
    }
    @objc private func savePhoto() {
//        UIImageWriteToSavedPhotosAlbum(imageTake, nil, nil, nil)
        MyAwesomeAlbum.shared.albumName = "test3"
        MyAwesomeAlbum.shared.save(image: imageTake)
        session?.startRunning()
        imageView.removeFromSuperview()

    }

    @objc private func retake() {
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
        let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(screenHeight-(screenHeight*0.19)), width:CGFloat(screenWidth), height:CGFloat(screenHeight*0.1))
        
              
              // Create a UIView object which use above CGRect object.
        let greenView = UIView(frame: rectFrame)
//        greenView.center = CGPoint(x: CGFloat(screenWidth/2),
//                                   y: CGFloat(screenHeight-(screenHeight*0.05)))
              // Set UIView background color.
        
                greenView.backgroundColor = UIColor(rgb: 0xA87F8B)
        
        MyVariables.greenview = greenView
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)
        view.addSubview(greenView)
        view.addSubview(shutterButton)
        view.addSubview(RetakeButton)
        view.addSubview(HelpButton)
        //view.addSubview(greenView)
        view.addSubview(NextPhotoButton)
        gridView.backgroundColor = UIColor.clear
        gridView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(horizontalMargin)).isActive = true
        gridView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(-1 * horizontalMargin)).isActive = true
        gridView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(verticalMargin)).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-1 * verticalMargin)).isActive = true
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
