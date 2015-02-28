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
var sidebarIsOpen: Bool?

protocol FoursquareTableViewControllerDelegate{
    func toggleLeftPanel()
    func collapseSidePanels()
}



class FoursquareTableViewController: UITableViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, LeftViewControllerDelegate {
    
    @IBOutlet var mainView: UITableView!
    let locationManager = CLLocationManager()
    let token = "RCUZDDM4FF2IPQHBHQ51RKJMFMMY1WBM3UVXFGAVN2DICCAA"
    let versionAPI = 20150227
    var coordinate: String = ""
    var delegate: FoursquareTableViewControllerDelegate? //

    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var contentOffset: CGPoint = self.tableView.contentOffset
        contentOffset.y += CGRectGetHeight(self.tableView.tableHeaderView!.frame)
        self.tableView.contentOffset = contentOffset; // Search as headerView
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidebarIsOpen = false
        
        //UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 0., 320., 44.)];
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 44))
        self.tableView.tableHeaderView = searchBar
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        findMyNewLocation()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("findMyNewLocation"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        
       

    }
    
    @IBAction func settings_clicked(sender: AnyObject) {
        delegate?.toggleLeftPanel()
    }

//    @IBAction func menuButton(sender: AnyObject) {
//        
//        let viewWidth: CGFloat = self.mainView.frame.width
//        let viewHeight: CGFloat = self.mainView.frame.height
//        var x: CGFloat = sidebarIsOpen! ? 0 : viewWidth * 0.73
//        println(viewWidth)
//        
//        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: nil, animations: {
//            self.view.frame = CGRect(x: x, y: 0, width: viewWidth, height: viewHeight)
//            }, completion:  { _ in
//                sidebarIsOpen = !(sidebarIsOpen!)
//        })
//    }
//    
//    
//    @IBAction func swipeHappend(recognizer : UISwipeGestureRecognizer) {
//        
//        let viewWidth: CGFloat = self.mainView.frame.width
//        let viewHeight: CGFloat = self.mainView.frame.height
//        var x: CGFloat = (recognizer.direction == .Left) ? 0 : viewWidth * 0.73
//        
//        UIView.animateWithDuration(0.7, animations: {
//            self.view.frame = CGRect(x:x, y:0, width: viewWidth, height: viewHeight)
//            }, completion: { _ in
//                sidebarIsOpen = (recognizer.direction == .Left) ? false : true
//        })
//        
//    }
    
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
                          jsonArray.insert((JSON(json!)["response"]["venues"][i]["name"].string)!,atIndex: i)
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
