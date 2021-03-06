//
//  PlaceDetailsViewController.swift
//  ScavengerHunt
//
//  Created by Lauren Nicole Roth on 5/19/16.
//  Copyright © 2016 Lauren Nicole Roth. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps


class PlaceDetailsViewController: UIViewController, GMSMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var place: Place?
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var placeRating: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var address: UILabel!
    @IBOutlet var starRating: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var placeTitle = "Change me"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        placeName.numberOfLines = 3
        
        if let place = place {
            
            //Set navigation title
            self.navigationItem.title = place.name
            
            //Set place details
            placeName.text = placeTitle
            placeRating.text = "\(place.rating)"
//            starRating.image = StarRating.rating(place.rating)
            
            
            if let address = place.address {
                self.address.text = "Tap to drop pins to guess the location."
            }
            
            
            if (place.photo == nil) {
                let params : [String:AnyObject] = ["maxwidth" : 500,
                                                   "photoreference": "\(place.photoReference)",
                                                   "key" : Constants.Keys.GoogleKey]
                
                Alamofire.request(.GET, Constants.Url.GoogleApiPlaceSearchPhoto, parameters: params ).response{ (request, response, dataIn, error) in
                    
                    
                    //get back to main thread
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        if let imageData = dataIn {
                            self.placeImageView.image = UIImage(named: "default")
                        }
                    }
                }
            }
            else{
                placeImageView.image = UIImage(named: "default")
            }
            
            
 
            
            let longPressRecognizer = UITapGestureRecognizer(target: self, action: "longPressed:")
            self.view.addGestureRecognizer(longPressRecognizer)
            
            let coordinates : CLLocationCoordinate2D = CLLocationCoordinate2DMake(place.latitude, place.longitude)
            
            let camera : GMSCameraPosition = GMSCameraPosition(target:coordinates, zoom:15, bearing:0, viewingAngle:0)
            
            self.mapView.camera = camera
            self.mapView.myLocationEnabled = true
            self.mapView.delegate = self;
            
        }
        
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        marker.title =  placeTitle
        marker.icon =  UIImage(named:"locationPin")
        checkMarkerPlacement(coordinate)
    }
    
    func checkMarkerPlacement(coordinates: CLLocationCoordinate2D) {
        
        let pinnedLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let accurateLocation = CLLocation(latitude: place!.latitude, longitude: place!.longitude)
        let distance = accurateLocation.distanceFromLocation(pinnedLocation) * 3.28084
        
        //If user guesses within 1000 ft, the answer is revealed!
        if distance < 1000.00 {
            addPhotoButton.hidden = true
            placeName.text = "Congrats! You found: " + place!.name
            address.text = place!.address
            placeImageView.image = place!.photo
            
        } else {
            placeName.text = "Correct location is \(distance) feet away!"
            print("Distance from correct location is: \(distance)")
        }
        
        
        
    }
    
    
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //customize navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        
    }
    
    
    @IBAction func loadWebsite(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        
        // TODO - Load more details about the location in a Web View after you've solved it 
        
    }
    
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
            placeImageView.image = photo
            dismissViewControllerAnimated(true, completion: nil)
            
            
            //MARK - TODO: Save this image to the place

        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
