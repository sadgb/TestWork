//
//  FoursquareTableViewController.swift
//  TestWork
//
//  Created by Anton Bednarzh on 27.02.15.
//  Copyright (c) 2015 Anton Bednarzh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

var tableData: Array<AnyObject> = []
let NotificationKey = "bednarzh.specialNotificationKey"
var jsonArray = Array<String>()



class FoursquareTableViewController: UITableViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationManager = CLLocationManager()
    let token = "RCUZDDM4FF2IPQHBHQ51RKJMFMMY1WBM3UVXFGAVN2DICCAA"
    let versionAPI = 20150227
    var coordinate: String = ""
    override func viewWillAppear(animated: Bool) {
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableData = ["Раз", "Два", "Три"]
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        findMyNewLocation()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("findMyNewLocation"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func findMyNewLocation(){
        println("Обновление местоположения")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    func foursquareRequestWith(coordinates:String, token: String) {
        
        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/search", parameters: ["ll": coordinate, "oauth_token": token, "v": versionAPI])
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        println("Error: \(error)")
                        println(req)
                        println(res)
                    }
                    else {
                        jsonArray.removeAll(keepCapacity: true)
                        println("Success: (url)")
                        
                        for var i = 0; i < 19 ;i++ {
                          jsonArray.insert((JSON(json!)["response"]["venues"][i]["name"].string!),atIndex: i)
                        //var json2 = JSON(json)["name"]
                        //let name = json["name"]
                        }
                        self.tableView.reloadData()

                        println(jsonArray)

                    }
                }
        }
    

    func foursquareDataDownloadSuccess(){
        println("Нотификация!!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return jsonArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = jsonArray[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
            coordinate = String(format: "%f,%f", containsPlacemark.location.coordinate.latitude, containsPlacemark.location.coordinate.longitude)
            println(coordinate)
            foursquareRequestWith(coordinate,token: token)

        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }


}
