//
//  ViewController1.swift
//  Screwed
//
//  Created by Mikhael Gonzalez on 8/1/15.
//  Copyright (c) 2015 Frank Joseph Boccia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController1: UIViewController, LocationManagerDelegate{
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var currentLoc: UIButton!
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.plotOnMapWithCoordinates(latitude: latitude, longitude: longitude)
            }
        }
        
//        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findCurrentLoc(sender: AnyObject) {
        println("clicked!")
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            println("passed")
            if error != nil {
                println(error)
            } else {
                self.plotOnMapWithCoordinates(latitude: latitude, longitude: longitude)
            }
        }
    }
        
    func locationManagerStatus(status:NSString){
        
        println(status)
    }
    
    
    func locationManagerReceivedError(error:NSString){
        
        println(error)
        
    }
    
    func locationFoundGetAsString(latitude: NSString, longitude: NSString) {
        
    }
    
    
    func locationFound(latitude:Double, longitude:Double){
            
        
    }
    
    func plotOnMapWithCoordinates(#latitude: Double, longitude: Double) {
        
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            
            self.performActionWithPlacemark(placemark, error: error)
        }
    }
    
    func performActionWithPlacemark(placemark:CLPlacemark?, error:String?) {
        
        if error != nil {
            println(error)
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.plotPlacemarkOnMap(placemark)
            })
        }
    }
    
    func removeAllPlacemarkFromMap(#shouldRemoveUserLocation:Bool) {
        
        if let mapView = self.Map {
            for annotation in mapView.annotations{
                if shouldRemoveUserLocation {
                    if annotation as? MKUserLocation !=  mapView.userLocation {
                        mapView.removeAnnotation(annotation as! MKAnnotation)
                    }
                }
            }
        }
    }
    
    func plotPlacemarkOnMap(placemark:CLPlacemark?) {
        
        removeAllPlacemarkFromMap(shouldRemoveUserLocation:true)
        
        if self.locationManager.isRunning {
            self.locationManager.stopUpdatingLocation()
        }

        var latDelta:CLLocationDegrees = 0.1
        var longDelta:CLLocationDegrees = 0.1
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var latitudinalMeters = 100.0
        var longitudinalMeters = 100.0
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark!.location.coordinate, latitudinalMeters, longitudinalMeters)
        
        self.Map?.setRegion(theRegion, animated: true)
        
        self.Map?.addAnnotation(MKPlacemark(placemark: placemark))
        println("here")
    }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
