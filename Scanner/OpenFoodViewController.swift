//
//  OpenFoodViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 29/04/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

class OpenFoodViewController: UIViewController {

    var codeBarreTransfered: String = ""

    @IBOutlet weak var codeBarreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        codeBarreLabel.text = codeBarreTransfered

        
    }


    


}
