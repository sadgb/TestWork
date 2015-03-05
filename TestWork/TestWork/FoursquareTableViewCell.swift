//
//  FoursquareTableViewCell.swift
//  TestWork
//
//  Created by Anton Bednarzh on 01.03.15.
//  Copyright (c) 2015 Anton Bednarzh. All rights reserved.
//

import UIKit
import CoreData

var favoritePlaces:Array<String> = []

class FoursquareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placesNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func favouriteButtonPressed(sender: UIButton) {

        if sender.selected == false{
            sender.selected = true
            
            var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context: NSManagedObjectContext = AppDel.managedObjectContext!
            var newFavoritePlace = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: context) as! NSManagedObject
            if isSearching == false {
                if (find(favoritePlaces, jsonArray[sender.tag]) == nil){
                newFavoritePlace.setValue(jsonArray[sender.tag], forKey: "namePlace")
                context.save(nil)
                }
            }else{
                if (find(favoritePlaces, searchArray[sender.tag]) == nil){
                newFavoritePlace.setValue(searchArray[sender.tag], forKey: "namePlace")
                context.save(nil)
                }
            }
            
        } else {
            sender.selected = false

            var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context: NSManagedObjectContext = AppDel.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "Favorite")
            let items = context.executeFetchRequest(fetchRequest, error: nil)!
            if isSearching == false {
                let findPlace = find(favoritePlaces, jsonArray[sender.tag])
                if (findPlace != nil){
                    favoritePlaces.removeAtIndex(findPlace!) //
                    context.deleteObject(items[findPlace!] as! NSManagedObject)
                    context.save(nil)
                    }
            }else{
                let findPlace = find(favoritePlaces, searchArray[sender.tag])
                if (findPlace != nil){
                    favoritePlaces.removeAtIndex(findPlace!) //
                    context.deleteObject(items[findPlace!] as! NSManagedObject)
                    context.save(nil)
                    }
                }
            }
        }
}
