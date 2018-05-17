//
//  detailsViewController.swift
//


import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource {

    // ***********************************************
    // MARK: - Interface
    // ***********************************************
    // Public
    var product: Product?
    // IBOutlet
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var allergensProductNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ui_tableView: UITableView!
    // ***********************************************
    // MARK: - Implementation
    // ***********************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        //link de la table avec "son" controller
        ui_tableView.dataSource = self

        backButton.layer.cornerRadius = 25

        codeLabel.text = product?.barCode
        productNameLabel.text = product?.name

        for ingredient in product?.ingredients ?? [] {
            print("\(ingredient)")
        }
        
        let allergenValue = product?.allergens?.isEmpty == true ? "Pas d'allergéne" : "Allergénes: \(product!.allergens!)"
        self.allergensProductNameLabel.text = allergenValue
    } // end of :     override func viewDidLoad()



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    } // end of : func tableView(_ tableView: UITableView...



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "number-Cell", for: indexPath)

        if let titleLabel = cell.textLabel {

            titleLabel.text = ingredientsArray[indexPath.row]
        }
        return cell
    } // end of : func tableView(_ tableView: UITableView...

    
    
} // end of : class detailsViewController: UIViewController, UITableViewDataSource



