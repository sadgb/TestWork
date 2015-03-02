//
//  FoursquareTableViewCell.swift
//  TestWork
//
//  Created by Anton Bednarzh on 01.03.15.
//  Copyright (c) 2015 Anton Bednarzh. All rights reserved.
//

import UIKit
import CoreData

class FoursquareTableViewCell: UITableViewCell {
    
    //var places: Array<String> = NSUserDefaults.standardUserDefaults().objectForKey("places") as Array<String>
    var favoritePlaces:Array<AnyObject> = []
    



    @IBOutlet weak var placesNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favouriteButtonPressed(sender: UIButton) {

        //favoriteButton .selected
        //println( favoriteButton.tag)
        //favoriteButton.selected = true
//        NSUserDefaults.standardUserDefaults().integerForKey("numberOperation"))){
        
//            resultLabel.text? = (NSUserDefaults.standardUserDefaults().objectForKey("resultMagic") as String)
//
//                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "magicOn")
//                NSUserDefaults.standardUserDefaults().synchronize()
        

        
        var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = AppDel.managedObjectContext!
        
        var newFavoritePlace = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: context) as NSManagedObject

       // dispatch_async(dispatch_get_main_queue(), {
            
            if sender.selected == false{
                sender.selected = true

                println(sender.tag)
                newFavoritePlace.setValue(jsonArray[sender.tag], forKey: "namePlace")
                
                context.save(nil)
            
                //println(newFavoritePlace)
            
            } else {
                sender.selected = false
                
                //var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
               // var context: NSManagedObjectContext = AppDel.managedObjectContext!
                //context.deleteObject(<#object: NSManagedObject#>)
                
//                let logItemToDelete = logItems[indexPath.row]
//                
//                // Delete it from the managedObjectContext
//                managedObjectContext?.deleteObject(logItemToDelete)
                
                
               // self.favoritePlaces.removeAtIndex(sender.tag)
               // println( self.favoritePlaces)

            }
       // })
    }

}
