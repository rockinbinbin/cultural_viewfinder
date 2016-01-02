//
//  listItem.swift
//  list
//
//  Created by Robin Mehta on 12/11/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewCellDelegate {
    func toDoItemDeleted(todoItem: NSManagedObject)
}

class listItem: UITableViewCell {
    
    var item : NSManagedObject?
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    
    var delegate: TableViewCellDelegate?
    
    internal lazy var companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.translatesAutoresizingMaskIntoConstraints = false;
        companyLabel.numberOfLines = 0
        companyLabel.textColor = UIColor.grayColor()
        companyLabel.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        self.contentView.addSubview(companyLabel)
        return companyLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        companyLabel.centerInSuperview()
        companyLabel.sizeToWidth(bounds.size.width - 50)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        let originalFrame = CGRect(x: 0, y: frame.origin.y,
            width: bounds.size.width, height: bounds.size.height)
        
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
            if deleteOnDragRelease {
                if delegate != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.toDoItemDeleted(item!)
                }
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }

}
