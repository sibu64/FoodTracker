//
//  ViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 24/04/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//



import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var codeLabel: UILabel!

    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Scanner"
        view.backgroundColor = .white

        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {

            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                let captureSession = AVCaptureSession()
                captureSession.addInput(input)

                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType

                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)

            } catch {
                print("Error Device Input")
            }

        }

    }


//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//        print(">>>>>>>>>>>>>> \(metadataObjects.count)")
//
////        if metadataObjects.count == 0 {
////            print("no Input Detected")
////            return
////        }
//
//        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//        guard let stringCodeValue = metadataObject.stringValue else { return }
//        // Create some label and assign returned string value to it
//
//        print("++++++++++++++ \(stringCodeValue)")
//        codeLabel.text = stringCodeValue
//        // Perform further logic needed (ex. redirect to other ViewController)
//
//    }

    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        //print(">>>>>>>>>>>>>> \(metadataObjects.count)")

        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }

        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        guard let stringCodeValue = metadataObject.stringValue else { return }

        view.addSubview(codeFrame)

        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue

        print("detected : \(stringCodeValue)")

//        // Play system sound with custom mp3 file
//        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
//            var customSoundId: SystemSoundID = 0
//            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &amp;customSoundId)
//            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
//
//            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
//                AudioServicesDisposeSystemSoundID(customSoundId)
//            }, nil)
//
//            AudioServicesPlaySystemSound(customSoundId)
//        }

        //captureSession?.stopRunning()

        displayDetailsViewController(scannedCode: stringCodeValue)

    }

    func displayDetailsViewController(scannedCode: String) {
        let detailsViewController = DetailsViewController()
        detailsViewController.scannedCode = scannedCode
        //navigationController?.pushViewController(detailsViewController, animated: true)
        present(detailsViewController, animated: true, completion: nil)
    }

}








