//
//  ViewController.swift
//  EarScanner_XCode
//
//  Created by James Noye on 30/7/21.
//
import AVFoundation
import UIKit
import Foundation
import EasyPeasy


class ViewController: UIViewController {
    //used for tracking when to show tutorials,
    static var photoCount = 0;
    //used for tracking what number to display
    static var counter = 0
    static var howLongIsBar = 6;
    static var SecondEar = false;
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    var alreadyRetaken = false
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
        self.containerWidth/12
    }
    var lineWidth: CGFloat {
        self.containerWidth/18
    }
    var padding: CGFloat {
        self.containerWidth/45
    }
    
    let containerView = UIView()
    
    var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    
    let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let view3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let view4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let view5: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    
    let view6: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let line2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let line3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let line4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
        return view
    }()
    let line5: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.alpha = 0.35
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
       
        button.setTitle("\(ViewController.counter)",for: .normal)
        
        
        //button.setTitle("\(items)",for: .normal)
        return button
    }();
    
   

    //the button to retake the photo
    private let RetakeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "gobackward", withConfiguration: largeTitle), for: .normal)
        //button.setTitle("Retake", for: .normal)
        
        return button
    }()
    
    private let ExitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: largeTitle), for: .normal)
        //button.setTitle("Retake", for: .normal)
        
        return button
    }()
    //button to move to the next photo
    /*private let NextPhotoButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        button.backgroundColor = .black
        button.setTitle("Next Photo", for: .normal)
        
        return button
    }()*/
    
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
        
        HelpButton.addTarget(self, action: #selector(tutorialPage), for: .touchUpInside)
        ExitButton.addTarget(self, action: #selector(exitCameraFlow), for: .touchUpInside)
        
        
        
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
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*(0.145/3)) )
        /*NextPhotoButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
                                         y: MyVariables.screenHeight - (MyVariables.screenHeight*0.3) )*/
       
        shutterButton.center = CGPoint(x: (MyVariables.screenWidth/2) ,
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*(0.19/2)) )
        
        RetakeButton.center = CGPoint(x:  MyVariables.screenWidth*0.80,
                                         y: MyVariables.screenHeight - (MyVariables.screenHeight*(0.145/3)) )
        
        ExitButton.center = CGPoint(x:  MyVariables.screenWidth*0.10,
                                    y: MyVariables.screenHeight - (MyVariables.screenHeight*0.85) )
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
        alreadyRetaken = false
        //increment counter on button press
//        MyVariables.counter += 1;
            
        
    }

    
}



extension ViewController: AVCapturePhotoCaptureDelegate {
 
    struct MyVariables {
        static var yourVariable = false
        static var bottomPinkBar = UIView()
        
        static var screenWidth = CGFloat(0.1);
        static var screenHeight = CGFloat(0.1);
        //counter for button and progress bar
//        static var counter = 0;

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
        //NextPhotoButton.removeFromSuperview()
        RetakeButton.removeFromSuperview()
        
        imageView.frame = view.bounds
        
        view.addSubview(imageView)

       
        view.addSubview(MyVariables.bottomPinkBar)
        
        ViewController.counter += 1
        let shutterButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            button.layer.cornerRadius = 50
            button.layer.borderWidth = 5
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.backgroundColor = UIColor.lightGray.cgColor
            /*Counter */

            button.setTitle("\(ViewController.counter)",for: .normal)


            //button.setTitle("\(items)",for: .normal)
            return button
        }()
        print("count2: ", ViewController.photoCount)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        shutterButton.center = CGPoint(x: (MyVariables.screenWidth/2) ,
                                       y: MyVariables.screenHeight - (MyVariables.screenHeight*(0.19/2)) )
        
        view.addSubview(shutterButton)
     
        view.addSubview(RetakeButton)
        
        view.addSubview(HelpButton)
        //view.addSubview(bottomPinkBar)
        //view.addSubview(NextPhotoButton)
        let seconds2 = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
            
            
            
         

if (ViewController.howLongIsBar == 6){
        UIView.animate(withDuration: 0.7) { [weak self] in
            guard let self = self else {
                return
            }
            print("progress",self.currentProgress)
            switch self.currentProgress {
            case 0:
                self.view1.alpha = 1
                self.view1.backgroundColor = .systemGreen
                
            case 1:
                self.view2.alpha = 1
                self.view2.backgroundColor = .systemGreen
                self.line1.alpha = 1
                self.line1.backgroundColor = .systemGreen
            case 2:
                self.view3.alpha = 1
                self.view3.backgroundColor = .systemGreen
                self.line2.alpha = 1
                self.line2.backgroundColor = .systemGreen

            case 3:
                self.view4.alpha = 1
                self.view4.backgroundColor = .systemGreen
                self.line3.alpha = 1
                self.line3.backgroundColor = .systemGreen
            case 4:
                self.view5.alpha = 1
                self.view5.backgroundColor = .systemGreen
                self.line4.alpha = 1
                self.line4.backgroundColor = .systemGreen
            case 5:
                self.view6.alpha = 1
                self.view6.backgroundColor = .systemGreen
                self.line5.alpha = 1
                self.line5.backgroundColor = .systemGreen
         
            default:
                self.view1.alpha = 0.35
                self.view1.backgroundColor = .systemOrange
            }
            if self.currentProgress > 4 {
                self.currentProgress = 0
                self.view1.alpha = 0.35
                self.view1.backgroundColor = .systemOrange
                self.view2.alpha = 0.35
                self.view2.backgroundColor = .systemOrange
                self.line1.alpha = 0.35
                self.line1.backgroundColor = .systemOrange
                self.view3.alpha = 0.35
                self.view3.backgroundColor = .systemOrange
                self.line2.alpha = 0.35
                self.line2.backgroundColor = .systemOrange
                self.view4.alpha = 0.35
                self.view4.backgroundColor = .systemOrange
                self.line3.alpha = 0.35
                self.line3.backgroundColor = .systemOrange
                self.view5.alpha = 0.35
                self.view5.backgroundColor = .systemOrange
                self.line4.alpha = 0.35
                self.line4.backgroundColor = .systemOrange
                self.view6.alpha = 0.35
                self.view6.backgroundColor = .systemOrange
                self.line5.alpha = 0.35
                self.line5.backgroundColor = .systemOrange
            } else {
                self.currentProgress += 1
            }
    }
}
else if (ViewController.howLongIsBar == 4){
                    UIView.animate(withDuration: 0.7) { [weak self] in
                        guard let self = self else {
                            return
                        }
                        print("progress",self.currentProgress)
                        switch self.currentProgress {
                        case 0:
                            self.view1.alpha = 1
                            self.view1.backgroundColor = .systemGreen
                            
                        case 1:
                            self.view2.alpha = 1
                            self.view2.backgroundColor = .systemGreen
                            self.line1.alpha = 1
                            self.line1.backgroundColor = .systemGreen
                        case 2:
                            self.view3.alpha = 1
                            self.view3.backgroundColor = .systemGreen
                            self.line2.alpha = 1
                            self.line2.backgroundColor = .systemGreen

                        case 3:
                            self.view4.alpha = 1
                            self.view4.backgroundColor = .systemGreen
                            self.line3.alpha = 1
                            self.line3.backgroundColor = .systemGreen
                        default:
                            self.view1.alpha = 0.35
                            self.view1.backgroundColor = .systemOrange
                            
                        }
                        if self.currentProgress > 2 {
                            self.currentProgress = 0
                            self.view1.alpha = 0.35
                            self.view1.backgroundColor = .systemOrange
                            self.view2.alpha = 0.35
                            self.view2.backgroundColor = .systemOrange
                            self.line1.alpha = 0.35
                            self.line1.backgroundColor = .systemOrange
                            self.view3.alpha = 0.35
                            self.view3.backgroundColor = .systemOrange
                            self.line2.alpha = 0.35
                            self.line2.backgroundColor = .systemOrange
                            self.view4.alpha = 0.35
                            self.view4.backgroundColor = .systemOrange
                            self.line3.alpha = 0.35
                            self.line3.backgroundColor = .systemOrange
                            
                        } else {
                            self.currentProgress += 1
                        }
                }
            }
            
            
        }

        imageTakePast = imageTake
        
        
        imageTake = image
        if (Retake != true){
//            MyAwesomeAlbum.shared.albumName = "RemovalTest"
            
            MyAwesomeAlbum.shared.save(image: self.imageTakePast)
            ViewController.photoCount += 1;
        }
        Retake = false
        
        //NextPhotoButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        
        RetakeButton.addTarget(self, action: #selector(retake), for: .touchUpInside)
        
        
        let seconds = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            if (ViewController.photoCount == 5){
                    //5
                
                
                print("changing the page")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step2")
                
                self.present(balanceViewController, animated: true, completion: nil)
            }
            else if (ViewController.photoCount == 11){
                self.currentProgress = 0
                ViewController.howLongIsBar = 4
                self.containerView.removeFromSuperview()
                self.addGridView()
                //11
                //add the line to save the last photo due to how I delay saving for retaking
                print("changing the page")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step3")
                
                self.present(balanceViewController, animated: true, completion: nil)
            }
            else if (ViewController.photoCount == 23){
                //23
                //add the line to save the last photo due to how I delay saving for retaking
                ViewController.howLongIsBar = 6
                self.currentProgress = 0
              
                self.containerView.removeFromSuperview()
                self.addGridView()
                print("changing the page")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step4")
                
                self.present(balanceViewController, animated: true, completion: nil)
            }
            
            else if (ViewController.photoCount == 29){
                //29
                if (ViewController.SecondEar == false){
                    MyAwesomeAlbum.shared.save(image: self.imageTakePast)
                    ViewController.SecondEar = true;
                    ViewController.photoCount = 0
                    print("changing the page")
                    let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BeginNextEar")
                     self.addChild(childViewController)
                     self.view.addSubview(childViewController.view)
                     childViewController.didMove(toParent: self)
                }
                else{
                    MyAwesomeAlbum.shared.save(image: self.imageTakePast)
                    ViewController.SecondEar = false;
                    ViewController.photoCount = 0
                    print("changing the page")
                    let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishedSet")
                     self.addChild(childViewController)
                     self.view.addSubview(childViewController.view)
                     childViewController.didMove(toParent: self)
                    
                }
            
        }
            
            print("count",ViewController.photoCount)
            self.session?.startRunning()
            self.imageView.removeFromSuperview()
            

        }

        
        
        
        
    }
    @objc private func savePhoto() {
//        UIImageWriteToSavedPhotosAlbum(imageTake, nil, nil, nil)
       
    }
    @objc private func tutorialPage() {
        self.containerView.removeFromSuperview()
        self.addGridView()
        
        
        print("changing the page")
        if (ViewController.photoCount <= 4){
            //step1
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step1-2")
            
            self.present(balanceViewController, animated: true, completion: nil)
        }
        else if (ViewController.photoCount <= 10){
            //step2
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step2")
            
            self.present(balanceViewController, animated: true, completion: nil)
        }
        else if (ViewController.photoCount <= 22){
            //step3
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step3")
            
            self.present(balanceViewController, animated: true, completion: nil)
        }
        else {
            //step4
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "Step4")
            
            self.present(balanceViewController, animated: true, completion: nil)
        }


        
        
        
    }
    @objc private func exitCameraFlow() {
        
        let refreshAlert = UIAlertController(title: "Exit Camera", message: "Are you sure you want to exit the camera? This photoset cannot be resumed once exited.", preferredStyle: UIAlertController.Style.alert) //create alert
        ViewController.photoCount = 0;
        ViewController.counter = 0;
        ViewController.SecondEar = false;
        

        refreshAlert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (action: UIAlertAction!) in
           
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
             self.addChild(childViewController)
             self.view.addSubview(childViewController.view)
             childViewController.didMove(toParent: self)
            self.navigationController?.popToRootViewController(animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in

            refreshAlert .dismiss(animated: true, completion: nil)


        }))

        present(refreshAlert, animated: true, completion: nil)
        print("ons")
        }
        

    @objc private func retake() {
        

        Retake = true;
        
        
        session?.startRunning()
        imageView.removeFromSuperview()
        print(self.currentProgress)
        
        if (alreadyRetaken == false){
            //reduce the number dsplayed by one, have to rremove, remake and reshow the shutter button in order to update the number
            shutterButton.removeFromSuperview()
            ViewController.counter -= 1
            let shutterButton: UIButton = {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                button.layer.cornerRadius = 50
                button.layer.borderWidth = 5
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.backgroundColor = UIColor.lightGray.cgColor
                /*Counter */

                button.setTitle("\(ViewController.counter)",for: .normal)


                //button.setTitle("\(items)",for: .normal)
                return button
            }()
            print("count2: ", ViewController.photoCount)
            shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
            view.addSubview(shutterButton)
            shutterButton.center = CGPoint(x: (MyVariables.screenWidth/2) ,
                                           y: MyVariables.screenHeight - (MyVariables.screenHeight*(0.19/2)) )
            
            alreadyRetaken = true
            ///De-progress the bar
            if (ViewController.howLongIsBar == 4){
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self = self else {
                    return
                }
                if self.currentProgress == 0 {
                    
                    self.currentProgress = 3
                    print("progress: ",self.currentProgress)
                } else {
                    
                    self.currentProgress -= 1
                    print("progress: ",self.currentProgress)
                }
                switch self.currentProgress {
                case 1:
                    self.view2.alpha = 0.35
                    self.view2.backgroundColor = .systemOrange
                    self.line1.backgroundColor = .systemOrange
                    self.line1.alpha = 0.35
                    
                case 2:
                    self.view3.alpha = 0.35
                    self.line2.alpha = 0.35
                    self.view3.backgroundColor = .systemOrange
                    self.line2.backgroundColor = .systemOrange
                case 3:
                    self.view1.alpha = 1
                    self.view1.backgroundColor = .systemGreen
                    self.view2.alpha = 1
                    self.view2.backgroundColor = .systemGreen
                    self.line1.alpha = 1
                    self.line1.backgroundColor = .systemGreen
                    self.view3.alpha = 1
                    self.view3.backgroundColor = .systemGreen
                    self.line2.alpha = 1
                    self.line2.backgroundColor = .systemGreen
                    
                    self.view4.alpha = 0.35
                    self.line3.alpha = 0.35
                    self.view4.backgroundColor = .systemOrange
                    self.line3.backgroundColor = .systemOrange
                default:
                    self.view1.alpha = 0.35
                    self.view2.alpha = 0.35
                    self.view1.backgroundColor = .systemOrange
                    self.view2.backgroundColor = .systemOrange
                    
                    self.line1.alpha = 0.35
                    self.view3.backgroundColor = .systemOrange
                    self.line1.backgroundColor = .systemOrange
                    self.view3.alpha = 0.35
                    
                    self.line2.alpha = 0.35
                    self.view4.alpha = 0.35
                    self.view4.backgroundColor = .systemOrange
                    self.line2.backgroundColor = .systemOrange
                    
                    self.line3.alpha = 0.35
                    self.line3.backgroundColor = .systemOrange
                }
               
            }
            }
            else if (ViewController.howLongIsBar == 6){
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self = self else {
                    return
                }
                if self.currentProgress == 0 {
                    
                    self.currentProgress = 5
                    print("progress: ",self.currentProgress)
                } else {
                    
                    self.currentProgress -= 1
                    print("progress: ",self.currentProgress)
                }
                switch self.currentProgress {
                case 1:
                    self.view2.alpha = 0.35
                    self.view2.backgroundColor = .systemOrange
                    self.line1.backgroundColor = .systemOrange
                    self.line1.alpha = 0.35
                    
                case 2:
                    self.view3.alpha = 0.35
                    self.line2.alpha = 0.35
                    self.view3.backgroundColor = .systemOrange
                    self.line2.backgroundColor = .systemOrange
                case 3:
                    self.view1.alpha = 1
                    self.view1.backgroundColor = .systemGreen
                    self.view2.alpha = 1
                    self.view2.backgroundColor = .systemGreen
                    self.line1.alpha = 1
                    self.line1.backgroundColor = .systemGreen
                    self.view3.alpha = 1
                    self.view3.backgroundColor = .systemGreen
                    self.line2.alpha = 1
                    self.line2.backgroundColor = .systemGreen
                    
                    self.view4.alpha = 0.35
                    self.line3.alpha = 0.35
                    self.view4.backgroundColor = .systemOrange
                    self.line3.backgroundColor = .systemOrange
                case 4:
                    self.view1.alpha = 1
                    self.view1.backgroundColor = .systemGreen
                    self.view2.alpha = 1
                    self.view2.backgroundColor = .systemGreen
                    self.line1.alpha = 1
                    self.line1.backgroundColor = .systemGreen
                    self.view3.alpha = 1
                    self.view3.backgroundColor = .systemGreen
                    self.line2.alpha = 1
                    self.line2.backgroundColor = .systemGreen
                    
                    self.view4.alpha = 1
                    self.line3.alpha = 1
                    self.view4.backgroundColor = .systemGreen
                    self.line3.backgroundColor = .systemGreen
                    
                    self.view5.alpha = 0.35
                    self.line4.alpha = 0.35
                    self.view5.backgroundColor = .systemOrange
                    self.line4.backgroundColor = .systemOrange
                    
                case 5:
                    self.view1.alpha = 1
                    self.view1.backgroundColor = .systemGreen
                    self.view2.alpha = 1
                    self.view2.backgroundColor = .systemGreen
                    self.line1.alpha = 1
                    self.line1.backgroundColor = .systemGreen
                    self.view3.alpha = 1
                    self.view3.backgroundColor = .systemGreen
                    self.line2.alpha = 1
                    self.line2.backgroundColor = .systemGreen
                    
                    self.view4.alpha = 1
                    self.line3.alpha = 1
                    self.view4.backgroundColor = .systemGreen
                    self.line3.backgroundColor = .systemGreen
                    
                    self.view5.alpha = 1
                    self.line4.alpha = 1
                    self.view5.backgroundColor = .systemGreen
                    self.line4.backgroundColor = .systemGreen
                    
                    self.view6.alpha = 0.35
                    self.line5.alpha = 0.35
                    self.view6.backgroundColor = .systemOrange
                    self.line5.backgroundColor = .systemOrange
                    
                default:
                    self.view1.alpha = 0.35
                    self.view2.alpha = 0.35
                    self.view1.backgroundColor = .systemOrange
                    self.view2.backgroundColor = .systemOrange
                    
                    self.line1.alpha = 0.35
                    self.view3.backgroundColor = .systemOrange
                    self.line1.backgroundColor = .systemOrange
                    self.view3.alpha = 0.35
                    
                    self.line2.alpha = 0.35
                    self.view4.alpha = 0.35
                    self.view4.backgroundColor = .systemOrange
                    self.line2.backgroundColor = .systemOrange
                    
                    self.line3.alpha = 0.35
                    self.line3.backgroundColor = .systemOrange
                }
               
            }
            }
        }
        else{
            let alert = UIAlertController(title: "Retaking", message: "Already retaking the photo", preferredStyle: UIAlertController.Style.alert) //create alert
                                    //I'm a pop up
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil)
            }
        
        
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
     let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(screenHeight-(screenHeight*0.10)), width:CGFloat(screenWidth), height:CGFloat(screenHeight*0.1))
        
              
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
        shutterButton.setTitle("\(ViewController.counter)",for: .normal)
        view.addSubview(shutterButton)
        //retake button
        view.addSubview(RetakeButton)
        //help
        view.addSubview(HelpButton)
        view.addSubview(ExitButton)
        //add to the view the exit button
       
        
        containerView.easy.layout(Top(padding).to(view.safeAreaLayoutGuide, .top), CenterX(), Width(containerWidth), Height(containerHeight*2))
        var viewSize2 = viewSize
        var lineWidth2 = lineWidth
        
        if (ViewController.howLongIsBar == 6){
        addViews(views: [view1, view2, view3, view4,view5,view6])
            addViews(views: [line1, line2, line3,line4,line5])}
        else{
            var viewSize: CGFloat {
                self.containerWidth/8
            }
            viewSize2 = viewSize
            
            var lineWidth: CGFloat {
                self.containerWidth/8
            }
            lineWidth2 = lineWidth
            addViews(views: [view1, view2, view3, view4])
                addViews(views: [line1, line2, line3])
        }
        view1.easy.layout(CenterY(), Left(padding).to(containerView, .left), Size(viewSize2))
        view1.rounded(radius: viewSize2/2)
        
        line1.easy.layout(CenterY(), Left(padding).to(view1, .right), Height(lineHeight), Width(lineWidth2))

        line1.rounded(radius: lineHeight/2)
        
        view2.easy.layout(CenterY(), Left(padding).to(line1, .right), Size(viewSize2))
        view2.rounded(radius: viewSize2/2)
        
        line2.easy.layout(CenterY(), Left(padding).to(view2, .right), Height(lineHeight), Width(lineWidth2))
        line2.rounded(radius: lineHeight/2)
        
        view3.easy.layout(CenterY(), Left(padding).to(line2, .right), Size(viewSize2))
        view3.rounded(radius: viewSize2/2)
        
        line3.easy.layout(CenterY(), Left(padding).to(view3, .right), Height(lineHeight), Width(lineWidth2))
        line3.rounded(radius: lineHeight/2)
        
        view4.easy.layout(CenterY(), Left(padding).to(line3, .right), Size(viewSize2))
        view4.rounded(radius: viewSize2/2)
        if (ViewController.howLongIsBar == 6){
        line4.easy.layout(CenterY(), Left(padding).to(view4, .right), Height(lineHeight), Width(lineWidth2))
        line4.rounded(radius: lineHeight/2)
        
        view5.easy.layout(CenterY(), Left(padding).to(line4, .right), Size(viewSize2))
        view5.rounded(radius: viewSize2/2)
        
        line5.easy.layout(CenterY(), Left(padding).to(view5, .right), Height(lineHeight), Width(lineWidth2))
        line5.rounded(radius: lineHeight/2)
        
        view6.easy.layout(CenterY(), Left(padding).to(line5, .right), Size(viewSize2))
        
        view6.rounded(radius: viewSize2/2)
        }
        view.addSubview(containerView)
    
        //view.addSubview(bottomPinkBar)
        //view.addSubview(NextPhotoButton)
        
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
 
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

          // if keyboard size is not available for some reason, dont do anything
          return
        }

        var shouldMoveViewUp = false

        // if active text field is not nil
        var bottomOfTextField: CGFloat;
        if let activeTextField = LoginViewController.activeTextField{
            
          bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
          
          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
          }
        

            if(shouldMoveViewUp && LoginViewController.whichView != "CheckCode") {
        
            LoginViewController.currentController?.view.frame.origin.y = 0 - (keyboardSize.height - ((self.view.frame.height - bottomOfTextField)*0.98))
        }
            else if(LoginViewController.whichView == "CheckCode"){
                LoginViewController.currentController?.view.frame.origin.y = 0 - (keyboardSize.height - ((self.view.frame.height - bottomOfTextField)*0.8))
            }
        }
          
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        LoginViewController.currentController?.view.frame.origin.y = 0
    }
    
    func disablesAutomaticKeyboardDismissal() -> Bool{
        return false;
    }
}
struct extensionsVariable{
    static var activeTextField : UITextField? = nil
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
