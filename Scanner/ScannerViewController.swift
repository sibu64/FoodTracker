//
//  ScannerViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 24/04/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//



import UIKit
import AVFoundation
import AudioToolbox

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {


    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    //var stringCodeValue: String?
    var scannedCode:String?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup de la vue
        navigationItem.title = "Scanner"
        view.backgroundColor = .white

        captureDevice = AVCaptureDevice.default(for: .video)

        //Si captureDevice retourne une valeur et la déballe
        if let captureDevice = captureDevice {

            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)

                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                //AVMetadataObject.ObjectType
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39]

                //lancement de la capture du code barre
                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)

            } catch {
                print("Problème avec le lecteur")
            }

        } //end of : if let captureDevice = captureDevice


        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    } //end of : override func viewDidLoad()



    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()

    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "Pas de données détectées"
            return
        }

        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        guard let stringCodeValue = metadataObject.stringValue else { return }

        view.addSubview(codeFrame)

        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue

        //print("++++++++++++++ \(stringCodeValue)")

        // Play system sound with custom mp3 file
        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines

            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)

            AudioServicesPlaySystemSound(customSoundId)
        }

        //Arrêt de la capture et de l'exécution de la fonction metadataOutput qui tourne en boucle
        captureSession?.stopRunning()

        //print("^^^^^^^^^^^ \(stringCodeValue)")
        self.scannedCode = stringCodeValue

//        //ça marcheAAA
//        displayOpenFoodViewController(scannedCode: stringCodeValue)

        performSegue(withIdentifier: "segueToOpenFood", sender: nil)


    } // end of : func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput ....



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("XXXXXXXXXX \(segue.identifier)")
        if segue.identifier == "segueToOpenFood" {
            //print("$$$$$$$$$$ \(scannedCode ?? "No scannedCode"))")
            if let code = scannedCode {
                if let nextScreen = segue.destination as? OpenFoodViewController {
                    nextScreen.scannedCode = code
                }
            }
        }
    }



    //ça marcheAAA
    func displayOpenFoodViewController(scannedCode: String) {
        let openFoodViewController = OpenFoodViewController()
        openFoodViewController.scannedCode = scannedCode
        //navigationController?.pushViewController(openFoodViewController, animated: true)
        present(openFoodViewController, animated: true, completion: nil)
    }

} // class ScannerViewController: UIViewController, AVCaptureMetadataOutput .....





