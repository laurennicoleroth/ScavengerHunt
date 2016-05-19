//
//  WelcomeViewController.swift
//  ScavengerHunt
//
//  Created by Lauren Nicole Roth on 5/19/16.
//  Copyright © 2016 Lauren Nicole Roth. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import GoogleMaps

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.alpha = 0.0
        setupLocationManager()
    }
    
    func setupLocationManager(){
        
        locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.distanceFilter = 100.0
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //stop location manager
        self.locationManager?.stopUpdatingLocation()
        
        if let currentLocation: CLLocation = locations.last {
            
            print(currentLocation)
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            
            print(latitude)
            print(longitude)
            
            getPlaces()
        }
        
    }
    
    
    func getPlaces(){
        
        let params: [String:AnyObject] = ["key": Constants.Keys.GoogleKey,
                                          "radius": "2000",
                                          "location": "\(latitude)," + "\(longitude)",
                                          "rankBy": "distance",
                                          "types": "museum"]
        
        Alamofire.request(.GET, Constants.Url.GoogleApiPlaceSearchJson, parameters: params)
            .responseJSON {
                response in
                if let data = response.data {
                    let json = JSON(data: data)
                    let places = PlaceJSONParser.createFrom(json)
                    self.viewPlaces(places)
                    
                    print(places)
                    
                    let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                    let geoCoder = GMSGeocoder()
                    geoCoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
                        (response, error) -> Void in
                        
                        let address = response?.firstResult()
                        print(address)
                        
                    })
                    
                    
                    
                }
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        //get coordinates from location manager
        showActivityIndicator()
        self.locationManager?.startUpdatingLocation()
        
    }
    
    
    func viewPlaces(places: [Place]) {
        
        hideActivityIndicator()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        if let placesTVC = storyboard.instantiateViewControllerWithIdentifier("PlacesTableViewController") as? PlacesTableViewController {
            placesTVC.googlePlaces = places
            self.navigationController?.pushViewController(placesTVC, animated: true)
        }
    }
    
    
    func showActivityIndicator() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.activityIndicator.alpha = 1.0
            
        }) { (Bool) -> Void in
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator(){
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.activityIndicator.alpha = 0.0
            
        }) { (Bool) -> Void in
            self.activityIndicator.stopAnimating()
        }
    }
    
}


