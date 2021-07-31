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
    
    private let RetakeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        button.setTitle("Retake", for: .normal)
        return button
    }()
    private let NextPhotoButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        button.setTitle("Next Photo", for: .normal)
        
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - (view.frame.size.height*0.18) )
        RetakeButton.center = CGPoint(x: view.frame.size.width - (view.frame.size.width*0.85),
                                       y: view.frame.size.height -  (view.frame.size.height*0.93) )
        NextPhotoButton.center = CGPoint(x:  view.frame.size.width*0.80,
                                       y: view.frame.size.height -  (view.frame.size.height*0.93) )
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
        
        AVCaptureDevice.ExposureMode.custom
        
        let session = AVCaptureSession()
       
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
                var tempgains = device.deviceWhiteBalanceGains(for: temp)
                //define a time element of 1/60 seconds
                var exposureTime = CMTimeMake(value: 1, timescale: 60)
                
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
        UIImageWriteToSavedPhotosAlbum(imageTake, nil, nil, nil)
        session?.startRunning()
        imageView.removeFromSuperview()

    }
    @objc private func retake() {
        session?.startRunning()
        imageView.removeFromSuperview()
        
    }
    
}





