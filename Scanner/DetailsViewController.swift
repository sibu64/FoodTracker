//
//  ViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 24/04/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

//Composition d'une vue par programmation
class DetailsViewController: UIViewController {

    var scannedCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        view.backgroundColor = .white

        //enfin, affichage du code détecté
        print(scannedCode!)
        
        
        // Setup label
        view.addSubview(codeLabel)
        codeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        codeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        if let scannedCode = scannedCode {
            codeLabel.text = scannedCode
        }

        // Setup button scan
        view.addSubview(scanButton)
        scanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

    } // end of : override func viewDidLoad() {


    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.textAlignment = .center
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    lazy var scanButton:UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.backgroundColor = .orange
        scanButton.layer.cornerRadius = 25
        scanButton.addTarget(self, action: #selector(displayScannerViewController), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scanButton
    }()


    @objc func displayScannerViewController() {
        print("123")
        let scanViewController = ScannerViewController()
        //navigationController?.pushViewController(scanViewController, animated: true)
        //navigationController?.present(scanViewController, animated: true, completion: nil)
        present(scanViewController, animated: true, completion: nil)
    }


} // end of : class DetailsViewController: UIViewController {



