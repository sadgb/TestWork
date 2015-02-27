//
//  ViewController.swift
//  TestWork
//
//  Created by Anton Bednarzh on 26.02.15.
//  Copyright (c) 2015 Anton Bednarzh. All rights reserved.
//

import UIKit
import CoreLocation

//var tableData: Array<AnyObject> = []

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource   {

    let locationManager = CLLocationManager()

    @IBOutlet weak var FoursquareTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableData = ["Раз", "Два", "Три"]
    self.FoursquareTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("findMyNewLocation"), forControlEvents: UIControlEvents.ValueChanged)
      //  self.refreshControl = refreshControl

        
    }
    
    func findMyNewLocation(){
        println("Обновление местоположения")
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func tableView(FoursquareTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(FoursquareTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.FoursquareTable.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = tableData[indexPath.row] as? String
        return cell
    }
    
    func tableView(FoursquareTable: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
//            println(locality)
//            println(postalCode)
//            println(administrativeArea)
//            println(country)
            println(containsPlacemark.location.coordinate.latitude)
            println(containsPlacemark.location.coordinate.longitude)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

