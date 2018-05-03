//
//  detailsViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 02/05/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {

        var codeLabel_in: String?
        var productNameLabel_in: String?

    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.cornerRadius = 25

        codeLabel.text = codeLabel_in
        productNameLabel.text = productNameLabel_in

    }



}
