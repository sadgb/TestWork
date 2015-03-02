
//
//  LeftViewController.swift
//  TestWork
//
//  Created by Anton Bednarzh on 28.02.15.
//  Copyright (c) 2015 Anton Bednarzh. All rights reserved.
//

import UIKit
import CoreData

protocol LeftViewControllerDelegate{
    
}

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: LeftViewControllerDelegate?
    var favoritePlaces: Array<AnyObject> = []


    @IBOutlet weak var favoritePlacesTableView: UITableView!
    override func viewWillAppear(animated: Bool) {

        var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = AppDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            for res in results{
                favoritePlaces.append(res.valueForKey("namePlace") as String)
            }
        } else {
            println("0 Results return...ERROR")
        }
        println(favoritePlaces)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(favoritePlacesTableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(favoritePlacesTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoritePlaces.count
    }
    
    
     func tableView(favoritePlacesTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell:UITableViewCell! = favoritePlacesTableView.dequeueReusableCellWithIdentifier("favoritePlaceCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = favoritePlaces[indexPath.row] as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            let fetchRequest = NSFetchRequest(entityName: "Favorite")
            fetchRequest.includesSubentities = false
            fetchRequest.returnsObjectsAsFaults = false
            
            //fetchRequest.predicate = NSPredicate(format:"name == '\(itemName)'")
            
            //var error: NSError?
            
            // moc is your NSManagedObjectContext here
            let items = context.executeFetchRequest(fetchRequest, error: nil)!
            
            //for item in items {
                context.deleteObject(items[indexPath.row] as NSManagedObject)
            
          //  tableView.beginUpdates()

            favoritePlaces.removeAtIndex(indexPath.row)

            
            context.save(nil)
            tableView.beginUpdates()

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.endUpdates()
            

        default:
            return
            
        }
//        var error:NSError? = nil
//        if !context.save(&error){
//            println(error)
//            abort()
        
    }
    
  }
