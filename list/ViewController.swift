//
//  ViewController.swift
//  list
//
//  Created by Robin Mehta on 12/10/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
//        // Hide the tableview until things loaded
//        tableView.hidden = true
//        tableView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(tableView)
        return tableView
    }()
    
    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.pinToEdgesOfSuperview()
        self.view.backgroundColor = UIColor.whiteColor()
        self.configureNavBar()

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
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.names.append(textField!.text!)
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

    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
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
        
        if (names.count > indexPath.row) {
            cell?.companyLabel.text = names[indexPath.row]
        }
        
        return cell!

    }
}

