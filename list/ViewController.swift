//
//  ViewController.swift
//  list
//
//  Created by Robin Mehta on 12/10/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    var items = [NSManagedObject]()
    var likedItems = [NSManagedObject]()
    
    var dateResults  = [NSManagedObject]()
    var date : NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.pinToEdgesOfSuperview()
        self.view.backgroundColor = UIColor.whiteColor()
        self.configureNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAllItems()
        self.fetchLikedItems()
        self.fetchDate()
        
        if (items.count == 0) {
            self.setInitialCoreData()
        }
        
        if (date == nil) {
            self.initializeDate()
        }
    }
    
    func fetchDate() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CurrentDate")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            dateResults = results as! [NSManagedObject]
            
            //print(dateResults)
            
            if (dateResults.count != 0) {
                date = NSDate()
                date = dateResults[dateResults.count - 1].valueForKey("date") as? NSDate
            }

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
//    func configureDate() {
//        let date = NSDate()
//        let calendar = NSCalendar.currentCalendar()
//        let hour = calendar.component(NSCalendarUnit.Hour, fromDate: date)
//        let minutes = calendar.component(NSCalendarUnit.Minute, fromDate: date)
//        let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
//        let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
//        let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
//    }
    
    func initializeDate() {
        
        date = NSDate()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("CurrentDate",
            inManagedObjectContext:managedContext)
        
        
        let currentDate = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        currentDate.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllItems() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            
            if (results.count != 0) {
                
            }
            
            items = results as! [NSManagedObject]
            
            //print(items)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func fetchLikedItems() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let predicate = NSPredicate(format: "liked = '1'")
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.predicate = predicate
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            likedItems = results as! [NSManagedObject]
            
            //print(likedItems)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 216/360, saturation: 0.14, brightness: 0.21, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(hue: 216/360, saturation: 0.14, brightness: 0.21, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        
        let navLabel = UILabel()
        navLabel.textColor = UIColor.whiteColor()
        navLabel.backgroundColor = UIColor.clearColor()
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        navLabel.text = "Today"
        self.navigationItem.titleView = navLabel
        navLabel.sizeToFit()
        
        let addButton  = UIBarButtonItem(image: UIImage(named: "whitePlus"), style: .Plain, target: self, action: Selector("addPressed"))
         addButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPressed() {
        let searchVC = SearchViewController()
        searchVC.items = items
        searchVC.likedItems = likedItems
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func createNewItem() {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func setInitialCoreData() {
        self.initializeItem("broccoli", category: "produce", liked: true)
        self.initializeItem("carrots", category: "produce", liked: true)
        self.initializeItem("chicken", category: "meat", liked: false)
        self.initializeItem("pasta", category: "grain", liked: true)
        self.initializeItem("chocolate", category: "dessert", liked: true)
        self.initializeItem("ice cream", category: "dessert", liked: true)
        self.initializeItem("zucchini", category: "produce", liked: false)
    }
    
    func initializeItem(name : String, category : String, liked : Bool) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Item",
            inManagedObjectContext:managedContext)

        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue(name, forKey: "name")
        item.setValue(category, forKey: "category")
        item.setValue(liked, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveName(name: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("Item",
            inManagedObjectContext:managedContext)
        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)

        item.setValue(name, forKey: "name")
        
//        if (name == "huh") {
//            item.setValue("produce", forKey: "category")
//            item.setValue(true, forKey: "liked")
//        }
//        
//        else {
//            item.setValue("meat", forKey: "category")
//            item.setValue(false, forKey: "liked")
//        }
        
        //print(item.valueForKey("name"))

        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "listItem"
        var cell: listItem? = tableView.dequeueReusableCellWithIdentifier(cellId) as? listItem
        
        //cell?.layoutSubviews()
        
        if cell == nil {
            cell = listItem()
            cell?.selectionStyle = .None
        }
        
        if (items.count > indexPath.row) {
            let item = items[indexPath.row]
            cell?.companyLabel.text = item.valueForKey("name") as? String
        }
        
        return cell!

    }
}

