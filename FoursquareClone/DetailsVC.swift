//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Admin on 7/19/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit
import Parse
import MapKit
class DetailsVC: UIViewController, MKMapViewDelegate {



    @IBOutlet weak var detailsplacename: UILabel!
    @IBOutlet weak var detailsplacetype: UILabel!
    @IBOutlet weak var detailsatmosphere: UILabel!
    @IBOutlet weak var detailsmapview: MKMapView!
    @IBOutlet weak var detailsImageView: UIImageView!
    var chosenPlaceId = ""
    var chosenLat = Double()
    var chosenLong = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getDataFromParse()
        detailsmapview.delegate = self
    }
    func getDataFromParse() {
        //get data from parse
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
            }else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        //Objects
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.detailsplacename.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.detailsplacetype.text = placeType
                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailsatmosphere.text = placeAtmosphere
                        }
                        //get lat and long from parse
                        if let placeLat = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatDouble = Double(placeLat){
                                self.chosenLat = placeLatDouble
                            }
                        }
                        if let placeLong = chosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongDouble = Double(placeLong){
                                self.chosenLong = placeLongDouble
                            }
                        }
                        //get image
                        if let imgData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imgData.getDataInBackground{(data, error) in
                                if error == nil {
                                    self.detailsImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                        
                        //Map of chosen location
                        let location = CLLocationCoordinate2D(latitude: self.chosenLat, longitude: self.chosenLong)
                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsmapview.setRegion(region, animated: true)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsplacename.text!
                        annotation.subtitle = self.detailsplacetype.text!
                        self.detailsmapview.addAnnotation(annotation)
                    }
                    
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = btn
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLong != 0.0 && self.chosenLat != 0.0 {
            //create a request location
            let requestL = CLLocation(latitude: self.chosenLat, longitude: self.chosenLong)
            
            CLGeocoder().reverseGeocodeLocation(requestL){(placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsplacename.text
                        
                        //navigation to the place by car
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        //Open in Apple Maps
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
        
        
    }
}
