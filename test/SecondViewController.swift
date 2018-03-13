//
//  SecondViewController.swift
//  test
//
//  Created by Krishan Wanarajan on 3/6/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import AVKit
import Vision

class SecondViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Here is where we start up the camera
        //NOTE: Will need to add privacy permissions in info.plist
        //Privacy - Camera Usage Description : We need to use the camera
        
        //Starts the camera session
        let captureSession = AVCaptureSession()
        
        //Sets the session preset
        //https://developer.apple.com/documentation/avfoundation/avcapturesession.preset/1620473-inputpriority
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        //Sets the captureDevice
        guard let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {return}
        
        //Sets the input, which is the capture device we set up initially
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        //Adds the input to the caputure session
        captureSession.addInput(input)
        
        //Starts the capture session
        captureSession.startRunning()
        
        //Creates the preview layer to show a preview of the camera
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {return}
        
        //Adds the preview layer as a sublayer to view controller
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)

        
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
//
        

        
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        //print("The Camera was able to capture a frame at: ", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        if #available(iOS 11.0, *) {
            guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
            
            let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                
               // print(finishedReq.results ?? "test")
                
                guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
                
                guard let firstobservation =  results.first else {return}
                
                print(firstobservation.identifier, firstobservation.confidence)
                
                DispatchQueue.main.async {
                    self.resultLabel.text = "\(firstobservation.identifier) \(firstobservation.confidence * 100)"
                }
                
            }
            
             try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButton(_ sender: Any) {
        
        
    }
    

}
