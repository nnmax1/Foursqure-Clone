//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Admin on 7/19/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit


class AddPlaceVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var placenameText: UITextField!
    @IBOutlet weak var placetypeText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeAtmosphereText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // add gesture recognizer
        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        //create instance of PlaceModel Singleton class
        if placenameText.text != "" && placetypeText.text != "" && placeAtmosphereText.text != "" {
            if let chosenImage = placeImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placenameText.text!
                placeModel.placeType = placetypeText.text!
                placeModel.placeAtmosphere = placeAtmosphereText.text!
                placeModel.placeImage = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            makeAlert(title: "Error", message: "Place name/type/atmosphere left empty.")
        }
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertBtn)
        self.present(alert, animated: true)
        
    }
    
}
