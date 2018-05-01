//
//  OpenFoodViewController.swift
//  Scanner
//
//  Created by jean-michel zaragoza on 29/04/2018.
//  Copyright © 2018 jean-michel zaragoza. All rights reserved.
//

import UIKit
import Alamofire

class OpenFoodViewController: UIViewController {

    //variables de classes utilisables dans toute les fonctions
    //de la classe, prcédées de "self"
    var scannedCode:String?
    var urlStringsProduit:String = ""
    var codeProduit:String = ""
    var senderTag = 0

    //Codage en dur des parties préfixe et suffixe de l'url
    let urlDeBase = "https://world.openfoodfacts.org/api/v0/produit/"
    let pointJSON = ".json"


    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var productLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = 25

        codeLabel.text = scannedCode

        //concaténation de l'url sur le format suivant
        //préfixe + codeProduit + pointJSON
        //https://world.openfoodfacts.org/api/v0/product/737628064502.json
        urlStringsProduit = urlDeBase + scannedCode! + pointJSON

        //print ("XXXXXXXXXXX : \(urlStringsProduit)")

        //la requête est constituée et stockée dans self.urlStringsProduit
        //attaque de la base de donnée en lançant la fonction :
        requeteDb()

    } // override func viewDidLoad()




    func requeteDb(){

        //test de validité de l'url sinon abandon
        guard let url = URL(string: urlStringsProduit)
            else {return}
        //si valide, creation de la requête type AlamoFire passant l'url urlStringsProduit
        //et demandant un retout JSON
        Alamofire.request(url).responseJSON { (response) in

            //l'objet REponse va récupérer l'objet RESponse
            if let reponse = response.value as? [String: AnyObject] {

                //Affichage de l'objet REponse complet récupéré
                print ("Result : \(reponse)")

                //ensuite pour parser le fichier JSON,
                //on descend d'1 cran dans l'arborescence du dictionnaire à partir de la racine
                //on trouve et stocke le noeud "product" dans infosProduit
                if let infosProduit = reponse["product"] as? [String: AnyObject] {

                    //on descend encore d'1 cran dans l'arborescence à partir de infosProduit
                    //on trouve et stocke le noeud "product_name_fr" dans nomProduit
                    if let nomProduit = infosProduit["product_name_fr"] as? String {

                        self.productLabel.text = ("\(nomProduit)")

                    }
                }
            }
        }

        if productLabel.text == "" {
            self.productLabel.text = "Produit non trouvé"
        }
    }



} // class OpenFoodViewController: UIViewController
