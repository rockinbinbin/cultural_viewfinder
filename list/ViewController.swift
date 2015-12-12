//
//  ViewController.swift
//  list
//
//  Created by Robin Mehta on 12/10/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData

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
        
        if (items.count == 0) {
            self.setInitialCoreData()
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
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Item",
            inManagedObjectContext:managedContext)
        
        var item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("broccoli", forKey: "name")
        item.setValue("produce", forKey: "category")
        item.setValue(true, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("carrots", forKey: "name")
        item.setValue("produce", forKey: "category")
        item.setValue(false, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("chicken", forKey: "name")
        item.setValue("meat", forKey: "category")
        item.setValue(false, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("pasta", forKey: "name")
        item.setValue("grain", forKey: "category")
        item.setValue(true, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("chocolate", forKey: "name")
        item.setValue("dessert", forKey: "category")
        item.setValue(true, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("ice cream", forKey: "name")
        item.setValue("dessert", forKey: "category")
        item.setValue(true, forKey: "liked")
        items.append(item)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        item.setValue("zucchini", forKey: "name")
        item.setValue("produce", forKey: "category")
        item.setValue(false, forKey: "liked")
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

