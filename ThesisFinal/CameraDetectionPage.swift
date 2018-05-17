//
//  CameraDetectionPage.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/12/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import AVKit
import Vision
import Firebase
import FirebaseDatabase

class CameraDetectionPage: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var captureButton: UIButton!
    
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?

    
    var profileInfo:profileInformation?
    
    var takePhoto = false
    //var clothingSize = sizeOnly(size: "")
    
    var sizeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (profileInfo != nil) {
//
//            resultLabel.text = profileInfo?.profileName
//
//
//
//        }
        
        
        // Do any additional setup after loading the view.
        
        //Here is where we start up the camera
        //NOTE: Will need to add privacy permissions in info.plist
        //Privacy - Camera Usage Description : We need to use the camera
        
        //Starts the camera session
        let captureSession = AVCaptureSession()
        
        //Sets the session preset
        //https://developer.apple.com/documentation/avfoundation/avcapturesession.preset/1620473-inputpriority
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        //Sets the captureDevice
        //guard let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {return}
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        
        
        
       // guard let captureDevice = AVCaptureDevice.default(for: AVMediaTypeAVMediaType.video) else {return}
        
        //Sets the input, which is the capture device we set up initially
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        //Adds the input to the caputure session
        captureSession.addInput(input)
        
        //Starts the capture session
        captureSession.startRunning()
        
        //Creates the preview layer to show a preview of the camera
         let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //Adds the preview layer as a sublayer to view controller
        view.layer.addSublayer(previewLayer)
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.sendSubview(toBack: cameraView)
        
        previewLayer.frame = cameraView.layer.bounds
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
        
        view.bringSubview(toFront: backButton)
        view.bringSubview(toFront: resultLabel)
        view.bringSubview(toFront: captureButton)

    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        ref = Database.database().reference()
        
        let displayname = Auth.auth().currentUser?.displayName
        
        //print("The Camera was able to capture a frame at: ", Date())
        
        
        if takePhoto {
            takePhoto = false
            
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
            
            if #available(iOS 11.0, *) {
                guard let model = try? VNCoreMLModel(for: SizeLengthClassifier().model) else {return}
                
                let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                    
                    // print(finishedReq.results ?? "test")
                    
                    guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
                    
                    guard let firstobservation =  results.first else {return}
                    
                    print(firstobservation.identifier, firstobservation.confidence)
                    
                    DispatchQueue.main.async {
                        self.resultLabel.text = "\(firstobservation.identifier) \(firstobservation.confidence * 100)"
                        
                        self.sizeArray.append("\(firstobservation.identifier)")
                        
                        let info = self.profileInfo?.profileName
                        
                        if info != nil {
                        
                            if let name = (self.profileInfo?.profileName)! as String? {
                            self.ref?.child("ProfileInformationSize").child(displayname!).child(name).setValue([firstobservation.identifier: firstobservation.identifier])
                            
                            }
                        }
                        
                    }
                    
                }
                
                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
                
            } else {
                // Fallback on earlier versions
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraCaptured(_ sender: Any) {
        takePhoto = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
