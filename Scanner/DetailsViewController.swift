//
//  detailsViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 02/05/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController, UITableViewDataSource {


    var codeLabel_in: String?
    var productNameLabel_in: String?
    var ingredientsArray:[String] = []



    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    

    @IBOutlet weak var ui_tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        //link de la table avec "son" controller
        ui_tableView.dataSource = self

        backButton.layer.cornerRadius = 25

        codeLabel.text = codeLabel_in
        productNameLabel.text = productNameLabel_in

        for ingredient in self.ingredientsArray {
            print("\(ingredient)")
        }
        print(ingredientsArray.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "number-Cell", for: indexPath)

        if let titleLabel = cell.textLabel {

            titleLabel.text = ingredientsArray[indexPath.row]
        }

        return cell
    }

}
