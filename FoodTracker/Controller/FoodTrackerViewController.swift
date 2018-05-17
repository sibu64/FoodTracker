//
//  FoodTrackerViewController.swift
//
//


import UIKit
import Kingfisher


class FoodTrackerViewController: UIViewController {
    // ***********************************************
    // MARK: - Interface
    // ***********************************************
    // IBOutlet
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!

    @IBOutlet weak var imageViewProduct: UIImageView!

    @IBOutlet weak var loader: UIActivityIndicatorView!
    // Public
    //variables de classes utilisables dans toute les fonctions
    //de la classe, précédées de "self"
    var scannedCode:String? = "7613034478405"
    private var product: Product?
    // ***********************************************
    // MARK: - Implementation
    // ***********************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = 25
        detailsButton.layer.cornerRadius = 25

        codeLabel.text = scannedCode
        productLabel.text = "Recherche..."
        
        let api = API()
        self.loader.startAnimating()
        api.searchProduct(with: scannedCode!, success: { (product) in
            dump(product)
            self.product = product
            self.codeLabel.text = product.barCode
            self.productLabel.text = product.name
            self.imageViewProduct.kf.setImage(with: product.imageUrl)
            self.loader.stopAnimating()
        }) { (error) in
            print(error)
            self.loader.stopAnimating()
        }
        
    } // override func viewDidLoad()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let controller = segue.destination as? DetailsViewController
            controller?.product = self.product
        } // end of : if segue.identifier == "segueToOpenFood"
    } // end of : override func prepare(for segue:

} // class OpenFoodViewController: UIViewController







