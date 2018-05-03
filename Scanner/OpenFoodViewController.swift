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
    var urlStringProduct:String = ""
    var urlStringImageProduct:String = ""
    var codeProduit:String = ""
    var ingredientsArray:[String] = []

    //Codage en dur des parties préfixe et suffixe de l'url
    let urlDeBase = "https://fr.openfoodfacts.org/api/v0/produits/"
    let pointJSON = ".json"

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!

    @IBOutlet weak var imageViewProduct: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = 25
        detailsButton.layer.cornerRadius = 25

        codeLabel.text = scannedCode
        productLabel.text = "Recherche..."

        //concaténation de l'url sur le format suivant :
        //préfixe + codeProduit + pointJSON
        urlStringProduct = urlDeBase + scannedCode! + pointJSON

        //print ("URL Concaténée : \(urlStringProduct)")

        //la requête est constituée et stockée dans self.urlStringProduct
        //attaque de la base de donnée en lançant la fonction :
        requeteDb()

        resultRequest()

    } // override func viewDidLoad()


    func requeteDb(){

        //test de validité de l'url sinon abandon
        guard let url = URL(string: urlStringProduct)
            else {return}
        //si valide, creation de la requête type AlamoFire passant l'url urlStringProduct
        //et demandant un retout JSON
        Alamofire.request(url).responseJSON { (response) in

            if response.error == nil {
                //print(response.error as Any)

                //l'objet REponse va récupérer l'objet RESponse
                if let reponse = response.value as? [String: AnyObject] {

                    //Affichage de l'objet REponse complet récupéré
                    //print ("reponse : \(reponse)")

                    //ensuite pour parser le fichier JSON.
                    //on descend d'1 cran dans l'arborescence du dictionnaire à partir de la racine
                    //on trouve et stocke le noeud "product" parmi les "clefs".
                    if let product = reponse["product"] as? [String: AnyObject] {

                        //on descend encore d'1 cran dans l'arborescence à partir de "product"
                        //on trouve et stocke le noeud "product_name_fr" dans "product_name_fr"
                        if let product_name_fr = product["product_name_fr"] as? String {

                            self.productLabel.text = ("\(product_name_fr)")
                            //self.productLabel.text = "Monsanto : Le meilleurs produit du monde pour empoisonner tout le monde"
                            //print ("\(product_name_fr)")
                        }

                        //au même niveau dans l'arborescence à partir de "product"
                        //on trouve et stocke le noeud "ingredients_ids_debug" dans "ingredients_ids_debug"
                        if let ingredients_ids_debug = product["ingredients_ids_debug"] as? [String] {

                            self.ingredientsArray = ingredients_ids_debug

//                            //mappage qui marche
//                            ingredients_ids_debug.map( { (ingredient) in
//                                print("\(ingredient)")
//                            })

//                            for ingredient in self.ingredientsArray {
//                                print("\(ingredient)")
//                            }

                            //self.productLabel.text = ("\(product_name_fr)")
                            //self.productLabel.text = "Monsanto : Le meilleurs produit du monde pour empoisonner tout le monde"
                            //print ("ingredients_ids_debug : \(ingredients_ids_debug)")

                            //au même niveau dans l'arborescence à partir de "product"
                            //on trouve et stocke le noeud "image_front_url" dans urlImage
                            if let urlImage = product["image_front_url"] as? String {

                                //print ("Image URL : \(urlImage)")
                                self.urlStringImageProduct = urlImage
                                //appel fonction
                                self.requestImageProduct()

                            } // end of : if let urlImage = product["image_front_url"] as? String

                        } // end of : if let ingredients_ids_debug = product
                    } // end of :  if let product = reponse["product"] as? [String: AnyObject]
                }  // end of : if let reponse = response.value.
            } // end of :  if response.error == nil
        } // end of : Alamofire.request(url).responseJSON { (response) in
    } // end of : func requeteDb()


    func resultRequest() {

        if productLabel.text == "Recherche..." {
            self.productLabel.text = "Produit non trouvé"
        }
    }


    func requestImageProduct() {

        //print ("ZZZ URL Image : \(self.urlStringImageProduct)")

        //la requête est constituée et stockée dans self.urlStringImageProduit
        //attaque de la base de donnée
        //test de validité de l'url sinon abandon
        guard let urlImage = URL(string: urlStringImageProduct)
            else {return}
        //si valide, creation de la requête type AlamoFire passant l'url urlStringProduct
        //et demandant un retout JSON
        Alamofire.request(urlImage).responseData { (responseImage) in

            if responseImage.error == nil {
                //print(responseImage.result)


                //l'objet REponse va récupérer l'objet RESponse
                if let reponseImage = responseImage.data {


                    //Affichage de l'objet REponseImage écupéré
                    self.imageViewProduct.image = UIImage(data: reponseImage)

                } // end of : if let reponseImage = responseImage
            } // if let reponseImage = responseImage
        } // end of : Alamofire.request(urlImage).response
    } // end of : func requestImageProduct()



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("XXXXXXXXXX \(segue.identifier)")
        if segue.identifier == "segueToDetails" {
            //print("$$$$$$$$$$ \(scannedCode ?? "No scannedCode"))")

                if let nextScreen = segue.destination as? detailsViewController {
                    nextScreen.codeLabel_in = codeLabel.text
                    nextScreen.productNameLabel_in = productLabel.text
                    nextScreen.ingredientsArray = self.ingredientsArray
                    
                }

        } // end of : if segue.identifier == "segueToOpenFood"
    } // end of : override func prepare(for segue: 

} // class OpenFoodViewController: UIViewController







