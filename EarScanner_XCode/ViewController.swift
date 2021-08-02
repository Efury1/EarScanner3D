//
//  ViewController.swift
//  EarScanner_XCode
//
//  Created by James Noye on 30/7/21.
//
import AVFoundation
import UIKit
import Foundation


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
    private let shutterButton: UIButton = {
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

    //if view has loaded make the background black (for simulator)
    //add the camera preview sub layer
    //and check permissions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        
        checkCameraPermissions()

    }
    //create the preview layer frames and place the buttons on them
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        
        RetakeButton.center = CGPoint(x: view.frame.size.width - (view.frame.size.width*0.85),
                                       y: view.frame.size.height -  (view.frame.size.height*0.85) )
        NextPhotoButton.center = CGPoint(x:  view.frame.size.width*0.80,
                                       y: view.frame.size.height -  (view.frame.size.height*0.85) )
        shutterButton.center = CGPoint(x: (view.frame.size.width/2)+10 ,
                                       y: view.frame.size.height - (view.frame.size.height*0.18) )
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
        
        
        imageView.frame = view.bounds
        view.addSubview(imageView)
        view.addSubview(RetakeButton)
        
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
    private func addGridView() {
        // cameraView is your view where you want to show the grid view
        let horizontalMargin = -10
        let verticalMargin = -10
        
        
        
        let gridView = GridView()
        gridView.addSubview(shutterButton)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)
        gridView.backgroundColor = UIColor.clear
        gridView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(horizontalMargin)).isActive = true
        gridView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(-1 * horizontalMargin)).isActive = true
        gridView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(verticalMargin)).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-1 * verticalMargin)).isActive = true
    }
}





