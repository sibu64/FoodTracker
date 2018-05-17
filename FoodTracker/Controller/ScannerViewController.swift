//
//  ScannerViewController.swift
//




import UIKit
import AVFoundation
import AudioToolbox

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {


    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?

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

                //Précision des AVMetadataObjectObjectType
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39]

                //Lancement de la capture du code barre
                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)

            } catch {
                print("Problème avec le lecteur")
            }

        } //end of : if let captureDevice = captureDevice

    } //end of : override func viewDidLoad()


    //Définition par code de la vue rectangle vert délimitant la zone scannée
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
            print("No Input Detected")
            codeFrame.frame = CGRect.zero
            return
        }

        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        guard let stringCodeValue = metadataObject.stringValue else { return }

        view.addSubview(codeFrame)

        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds


        //Bip sonore lorsque la capture scan est réalisée
        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            AudioServicesPlaySystemSound(customSoundId)
        }

        //Arrêt de la capture et de l'exécution de la fonction metadataOutput qui tourne en boucle
        captureSession?.stopRunning()

        self.scannedCode = stringCodeValue

        //Exécution automatique dès le scan réalisé vers l'écran suivant.
        //Cette exécution entraine l'appel préalable de la fonction "prepare"
        //laquelle va se charger de transmettre les données attendues sur l'écran suivant.
        performSegue(withIdentifier: "segueToOpenFood", sender: nil)

    } // end of : func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput ....


    //Fonction de préparation de transfert des données vers le "nextScreen"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToOpenFood" {
            if let code = scannedCode {
                if let nextScreen = segue.destination as? FoodTrackerViewController {
                    nextScreen.scannedCode = code
                }
            }
        } // end of : if segue.identifier == "segueToOpenFood"
    } // end of : override func prepare(for segue:


} // class ScannerViewController: UIViewController, AVCaptureMetadataOutput .....





