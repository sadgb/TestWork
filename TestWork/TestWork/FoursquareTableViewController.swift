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
import CoreData

var jsonArray = Array<String>()
var searchArray = Array<String>()
var sidebarIsOpen: Bool?
var selectedArray = Array(count: jsonArray.count, repeatedValue: false)
var isSearching: Bool = false


protocol FoursquareTableViewControllerDelegate{
    func toggleLeftPanel()
    func collapseSidePanels()
}

class FoursquareTableViewController: UITableViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, LeftViewControllerDelegate {
    
    @IBOutlet var mainView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 60, 60)) as UIActivityIndicatorView
    let locationManager = CLLocationManager()
    let token = "RCUZDDM4FF2IPQHBHQ51RKJMFMMY1WBM3UVXFGAVN2DICCAA"
    let versionAPI = 20150227
    var coordinate: String = ""
    var tableData: Array<AnyObject> = []
    var delegate: FoursquareTableViewControllerDelegate? //

    override func viewWillAppear(animated: Bool) {
        

        
        super.viewWillAppear(true)
        var contentOffset: CGPoint = self.tableView.contentOffset
        contentOffset.y += CGRectGetHeight(self.tableView.tableHeaderView!.frame)
        self.tableView.contentOffset = contentOffset; // Search as headerView
        
        var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            for res in results {
                if (res.valueForKey("namePlace") != nil){
                    let a = res.valueForKey("namePlace") as! String?
                    if (find(favoritePlaces, res.valueForKey("namePlace") as! String) == nil){
                        favoritePlaces.append(res.valueForKey("namePlace") as! String)
                    }
                }
            }
        } else {
            println("0 Results return")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidebarIsOpen = false
        isSearching = false
        
        self.tableView.tableHeaderView = searchBar
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        busyIndicatorActive()
        findMyNewLocation()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("findMyNewLocation"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        self.searchBar.delegate = self
        self.tableView.delaysContentTouches = false

    
    }
    
    @IBAction func settings_clicked(sender: AnyObject) {
        delegate?.toggleLeftPanel()
    }
    
    func findMyNewLocation(){
        //println("Обновление местоположения")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func busyIndicatorActive(){
//        let actFrame : CGRect = CGRectMake(0,80,80,80)
//        var actView : UIView = UIView(frame: actFrame)
//        actView.center = self.view.center
//        actView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
//        actView.alpha=0.5
//        self.view.addSubview(actView)

        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.color = UIColor(red:0.14, green:0.6, blue:0.7, alpha:1.0)
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func foursquareRequestWith(coordinates:String, token: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        

        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/search", parameters: ["ll": coordinate, "oauth_token": token, "v": versionAPI])
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        println("Error: \(error)")
                        //println(req)
                        //println(res)
                    } else {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        jsonArray.removeAll(keepCapacity: true)
                        //println("Success: (url)")
                        
                        for var i = 0; i < 19 ;i++ {
                          jsonArray.insert((JSON(json!)["response"]["venues"][i]["name"].string)!,atIndex: i)
                        }
                        self.actInd.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
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
        if isSearching == true {
            return searchArray.count
        } else {
            return jsonArray.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let  cell:FoursquareTableViewCell! = tableView.dequeueReusableCellWithIdentifier("FoursqareCell", forIndexPath: indexPath) as? FoursquareTableViewCell
        
        cell.favouriteButton.frame.origin.x = mainView.frame.size.width - 40
        cell.placesNameLabel.frame.size.width = mainView.frame.size.width - 60
        
        if isSearching == true {
            cell.placesNameLabel?.text = searchArray[indexPath.row]
            if find(favoritePlaces, searchArray[indexPath.row]) != nil {
                cell.favouriteButton.selected = true
            } else {
                cell.favouriteButton.selected = false
            }
        } else {
        cell.placesNameLabel?.text = jsonArray[indexPath.row]
        cell.favouriteButton.tag = indexPath.row //
            if find(favoritePlaces, jsonArray[indexPath.row]) != nil {
                cell.favouriteButton.selected = true
            } else {
                cell.favouriteButton.selected = false
            }
        }
        //println(jsonArray[indexPath.row])
        

        
        return cell
    }
    // Search Controller
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            searchArray.removeAll()
            for var index = 0; index < jsonArray.count; index++
            {
                var currentString = jsonArray[index] as String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchArray.append(currentString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""

            coordinate = String(format: "%f,%f", containsPlacemark.location.coordinate.latitude, containsPlacemark.location.coordinate.longitude)
            //println(coordinate)
            foursquareRequestWith(coordinate,token: token)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tableView.endEditing(true)
    }
    



}
