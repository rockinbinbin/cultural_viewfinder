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

// Core data:
// Item = pre-exploration questions
// Answer = question + answer + date + picture?
// Journal = collection of answers + city

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, journalFinished {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        self.view.addSubview(tableView)
        return tableView
    }()
    
    //var items = [NSManagedObject]()
    var likedItems = [NSManagedObject]()
    var journalItems = [NSManagedObject]()
    
    var addButtonPressed : Bool?
    
    var dateResults  = [NSManagedObject]()
    var date : NSDate?
    
    var newJournalView : NewJournalEditView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.createLayout()
        addButtonPressed = false
    }
    
    func createLayout() {
        tableView.pinToEdgesOfSuperview()
    }
    
    func reloadViewController() {
        addButtonPressed = false
        self.newJournalView?.hidden = true
        self.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.fetchAllItems()
        self.fetchLikedItems()
        self.fetchDate()
        self.fetchJournalItems()
        
        if (date == nil) {
            self.initializeDate()
        }
        
        if (journalItems.count == 0 || addButtonPressed == true) {
            
            // initialize view to create journal entry here
            if (newJournalView == nil) {
                newJournalView = NewJournalEditView(size: self.view.frame.size, ViewController: self)
                newJournalView?.delegate = self
                
            }
           self.view.addSubview(newJournalView!)
            newJournalView?.sizeToWidth(self.view.frame.size.width)
            newJournalView?.sizeToHeight(self.view.frame.size.height)
            self.navigationController?.navigationBarHidden = true
        }
        else {
            newJournalView = nil
            self.tableView.hidden = false
            self.navigationController?.navigationBarHidden = false
            self.configureNavBar()
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
    
//    func fetchAllItems() {
//        let appDelegate =
//        UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//
//        let fetchRequest = NSFetchRequest(entityName: "Item")
//        
//        do {
//            let results =
//            try managedContext.executeFetchRequest(fetchRequest)
//            
//            items = results as! [NSManagedObject]
//            
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//    }
    
    func fetchJournalItems() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Journal")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            
            journalItems = results as! [NSManagedObject]
            
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
        navLabel.text = "Trips"
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
//        let searchVC = SearchViewController()
//        searchVC.items = items
//        searchVC.likedItems = likedItems
//        self.navigationController?.pushViewController(searchVC, animated: true)
        addButtonPressed = true
        self.tableView.hidden = true
        self.newJournalView?.hidden = false
        self.viewWillAppear(true)
        //self.tableView.reloadData()
        
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
    
    func saveName(name: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("Item",
            inManagedObjectContext:managedContext)
        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)

        item.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            //items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func toDoItemDeleted(toDoItem: NSManagedObject) {
        let index = (journalItems as NSArray).indexOfObject(toDoItem)
        if index == NSNotFound { return }
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
//        let entity =  NSEntityDescription.entityForName("Item",
//            inManagedObjectContext:managedContext)
        
        managedContext.deleteObject(toDoItem)
        
        do {
            try managedContext.save()
            //items.removeAtIndex(index)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }

    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.journalItems.count
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
        
        if cell == nil {
            cell = listItem()
            cell?.selectionStyle = .None
        }
        
        cell!.delegate = self
        
//        let rect = CGRectMake(0, 0, self.view.frame.size.width, 100 * CGFloat(self.items.count))
//        let colorView = UIView(frame: rect)
//        colorView.backgroundColor = UIColor.greenColor()
//        //        colorView.alpha = 1.0
//        cell!.insertSubview(colorView, atIndex: 0)
//
//        cell?.backgroundColor = UIColor.whiteColor()
//        
        if (journalItems.count > indexPath.row) {
            let journal = journalItems[indexPath.row]
            cell!.item = journal
            cell?.companyLabel.text = journal.valueForKey("place") as? String
        }
        
        return cell!

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // journalItems[indexPath.row]
        let selectedJournalVC = SelectedJournal()
        
        if (journalItems.count > indexPath.row) {
            selectedJournalVC.journal = journalItems[indexPath.row]
            self.navigationController?.pushViewController(selectedJournalVC, animated: true)
        }
    }
}

