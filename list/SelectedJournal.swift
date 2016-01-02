//
//  SelectedJournal.swift
//  list
//
//  Created by Robin Mehta on 12/29/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData
import Foundation

// Core data:
// Item = pre-exploration questions
// Answer = question + answer + date + picture?
// Journal = collection of answers + city

class SelectedJournal: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = false
        self.view.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var journalTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.numberOfLines = 0
        title.textColor = UIColor.blackColor()
        title.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        title.textAlignment = .Left
        return title
    }()
    
    var journal : NSManagedObject?
    
    var journalItems : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.configureNavBar()
        self.createLayout()
        self.fetchItemRelations()
        self.navigationController?.navigationBarHidden = false
    }
    
    func fetchItemRelations() {
        let journalRelation = journal!.valueForKeyPath("relationship") as! NSSet
        journalItems = journalRelation.allObjects
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func createLayout() {
        self.view.addSubview(tableView)
        self.tableView.pinToEdgesOfSuperview()
        //self.view.addSubview(journalTitle)
//        journalTitle.pinToTopEdgeOfSuperview(offset: 50)
//        journalTitle.centerHorizontallyInSuperview()
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
        navLabel.text = journal?.valueForKey("place") as? String
        self.navigationItem.titleView = navLabel
        navLabel.sizeToFit()
        
        let backButton = UIButton(type: .Custom)
        backButton.setImage(UIImage(named: "backArrow"), forState: .Normal)
        let img = UIImage(named: "backArrow")!
        backButton.bounds = CGRectMake(0, 0, img.size.width, img.size.height)
        
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        //        let addButton  = UIBarButtonItem(image: UIImage(named: "whitePlus"), style: .Plain, target: self, action: Selector("addPressed"))
        //         addButton.tintColor = UIColor.whiteColor()
        //        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addPressed() {
        let searchVC = SearchViewController()
//        searchVC.items = items
//        searchVC.likedItems = likedItems
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.journalItems!.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "listItem"
        var cell: singleJournalDetailCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? singleJournalDetailCell
        
        if cell == nil {
            cell = singleJournalDetailCell()
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
        if (journalItems!.count > indexPath.row) {
            let journal = journalItems![indexPath.row]
            cell!.item = journal as? NSManagedObject
            cell?.companyLabel.text = journal.valueForKey("name") as? String
            cell?.answerLabel.text = journal.valueForKey("answer") as? String
        }
        return cell!
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // journalItems[indexPath.row]
//        let selectedJournalVC = SelectedJournal()
//        
//        if (journalItems!.count > indexPath.row) {
//            selectedJournalVC.journal = journalItems![indexPath.row] as? NSManagedObject
//            self.navigationController?.pushViewController(selectedJournalVC, animated: true)
//        }
//    }
    
    func toDoItemDeleted(toDoItem: NSManagedObject) {
        let index = (journalItems)!.indexOfObject(toDoItem)
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
    
}
