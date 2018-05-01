//
//  WecomeOpenFoodViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 01/05/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

class WecomeOpenFoodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {

        scanButton.layer.cornerRadius = 25

    }



    @IBOutlet weak var scanButton: UIButton!




}
