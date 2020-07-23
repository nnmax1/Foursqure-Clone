//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Admin on 7/22/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import Foundation
import UIKit

//Singleton class

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeLatitude = ""
    var placeLongitude = ""
    var placeImage = UIImage()
    
    private init () {}
}
