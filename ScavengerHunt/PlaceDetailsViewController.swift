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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        placeName.numberOfLines = 3
        
        if let place = place {
            
            //Set navigation title
            self.navigationItem.title = place.name
            
            //Set place details
            placeName.text = "Change Me" //place.name
            placeRating.text = "\(place.rating)"
//            starRating.image = StarRating.rating(place.rating)
            
            
            if let address = place.address {
                self.address.text = "Populate from dropped pin"
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
            
            
            //Display map
            let coordinates : CLLocationCoordinate2D = CLLocationCoordinate2DMake(place.latitude, place.longitude)
            
            let camera : GMSCameraPosition = GMSCameraPosition(target:coordinates, zoom:15, bearing:0, viewingAngle:0)
            
            self.mapView.camera = camera
            self.mapView.myLocationEnabled = true
            self.mapView.delegate = self;
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
            self.view.addGestureRecognizer(tapGestureRecognizer)
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
            self.view.addGestureRecognizer(longPressRecognizer)
            
            var touchPoint = longPressRecognizer.locationInView(mapView)
            //            var touchCoordinates =
            let marker : GMSMarker = GMSMarker()
            
            
            //
            //            let marker : GMSMarker = GMSMarker()
            //            marker.position = coordinates
            //            marker.title = place.name
            //            marker.icon =  UIImage(named:"locationPin")
            //            marker.map = self.mapView;
            
        }
        
    }
    
    
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
        
        print("add photo pressed")
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
//        if let webVC = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as? WebViewController {
//            
//            if let place = place {
//                webVC.name = place.name
//                webVC.url = place.website
//                self.navigationController?.pushViewController(webVC, animated: true)
//            }
//        }
        
    }
    
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
//            if let indexPath = tableView.indexPathForSelectedRow {
//                var selectedItem = googlePlaces![indexPath.row]
//                let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
//                selectedItem.photo = photo
//                dismissViewControllerAnimated(true, completion: {
//                    //                self.googlePlaces.save()
//                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                })
//            }
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
