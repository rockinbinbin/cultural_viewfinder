//
//  SearchViewController.swift
//  list
//
//  Created by Robin Mehta on 12/11/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    
    var items = [NSManagedObject]()
    var likedItems = [NSManagedObject]()
    
    var searchController : UISearchController?
    var searchResults : NSArray?
    var searchResultsTableViewController : UITableViewController?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.hidesBarsOnSwipe = false
        
        self.tableView.pinToEdgesOfSuperview()
        
        let backButton = UIButton(type: .Custom)
        backButton.setImage(UIImage(named: "backArrow"), forState: .Normal)
        let img = UIImage(named: "backArrow")!
        backButton.bounds = CGRectMake(0, 0, img.size.width, img.size.height)
        
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        
        let navLabel = UILabel()
        navLabel.textColor = UIColor.whiteColor()
        navLabel.backgroundColor = UIColor.clearColor()
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        navLabel.text = "Search"
        self.navigationItem.titleView = navLabel
        navLabel.sizeToFit()
        
        let searchResultsTableView = UITableView(frame: CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 44))
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        self.searchResultsTableViewController = UITableViewController()
        self.searchResultsTableViewController?.tableView = searchResultsTableView
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsTableViewController)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        
        self.searchController?.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.searchController?.searchBar.placeholder = "Search a grocery item"
        self.searchController?.searchBar.barTintColor = UIColor.whiteColor()
        self.searchController?.searchBar.tintColor = UIColor.whiteColor()
        self.searchController?.searchBar.layer.borderColor = UIColor.clearColor().CGColor
        
        if #available(iOS 9.0, *) {
            (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self])).tintColor = UIColor.blackColor()
        } else {
            // Fallback on earlier versions
        }
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        
        self.searchResults = NSMutableArray()
        
        if (self.tableView.hidden) {
            self.tableView.layer.opacity = 0.0
            self.tableView.hidden = false
            UIView.animateWithDuration(0.25) {
                self.tableView.layer.opacity = 1.0
            }
        }
    }
    
    deinit {
        searchController?.view .removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "productCell"
        var cell: listItem? = tableView.dequeueReusableCellWithIdentifier(cellId) as? listItem
        
        if cell == nil {
            cell = listItem()
            cell?.selectionStyle = .None
        }
        
        if (self.searchResults!.count > indexPath.row) {
            let item = self.searchResults![indexPath.row] as! NSManagedObject
            cell?.companyLabel.text = item.valueForKey("name") as? String
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchResults?.count > 0) {
            return (self.searchResults?.count)!
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    internal func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if (searchBar.text?.characters.count > 0) {
            let text = searchBar.text
            
            let predicate = NSPredicate(block: { (item : AnyObject, bindings : [String : AnyObject]?) -> Bool in
                if let managedObject = item as? NSManagedObject {
                    let range = (managedObject.valueForKey("name")?.rangeOfString(text!, options: .CaseInsensitiveSearch))!
                    if (range.location != NSNotFound) {
                        return true
                    }
                }
                return false
            })
            
            self.searchResults = self.items.filter { predicate.evaluateWithObject($0) }
            self.searchResultsTableViewController?.tableView.reloadData()
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
