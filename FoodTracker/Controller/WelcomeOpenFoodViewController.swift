//
//  WecomeOpenFoodViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 01/05/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

class WelcomeOpenFoodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        scanButton.layer.cornerRadius = 25
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "showSteve", sender: nil)
    }



    @IBOutlet weak var scanButton: UIButton!




}
