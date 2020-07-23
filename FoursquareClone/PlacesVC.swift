//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Admin on 7/19/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit
import Parse
class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArr =  [String]()
    var placeIDArr = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //add button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        //logout button
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title:"Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier:"toAddPlacesVC", sender: nil)
    }
    @objc func logoutButtonClicked() {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }else {
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
        }
    }
    //get data from Parse
    func getData() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground{ (objects, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }else {
                if objects != nil {
                    for object in objects! {
                        if let placeN = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId as? String {
                                self.placeNameArr.append(placeN)
                                self.placeIDArr.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIDArr[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destVC = segue.destination as! DetailsVC
            destVC.chosenPlaceId = selectedPlaceId
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArr.count
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertBtn)
        self.present(alert, animated: true)
        
    }
}
