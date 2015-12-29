//
//  newJournalEditView.swift
//  list
//
//  Created by Robin Mehta on 12/26/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    func fadeTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.addAnimation(animation, forKey: kCATransitionFade)
    }
}

public class NewJournalEditView: UIView, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {

    public lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.numberOfLines = 0
        title.textColor = UIColor.blackColor()
        title.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        title.textAlignment = .Left
        return title
    }()
    
    public lazy var nextButton: UIButton = {
       let nextButton = UIButton(type: .RoundedRect)
        nextButton.layer.cornerRadius = 5
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.blackColor().CGColor
        nextButton.tintColor = UIColor.blackColor()
        nextButton.setTitle("next >>", forState: .Normal)
    
        self.addSubview(nextButton)
        nextButton.addTarget(self, action: Selector("nextPressed"), forControlEvents: .TouchUpInside)
        
        return nextButton
    }()
    
    public lazy var plusButton: UIButton = {
        let plusButton = UIButton()
        let img = UIImage(named: "blackPlus")
        plusButton.setImage(img, forState: .Normal)
        
        plusButton.addTarget(self, action: Selector("plusPressed"), forControlEvents: .TouchUpInside)
        self.addSubview(plusButton)
        
        return plusButton
    }()
    
    var thisitems = [NSManagedObject]()
    
    var count = 0
    
    var firstAnswer : String?
    var secondAnswer : String?
    var thirdAnswer : String?
    var fourthAnswer : String?
    var fifthAnswer : String?
    
    
    public lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.translatesAutoresizingMaskIntoConstraints = false;
        cityTextField.delegate = self
        cityTextField.textColor = UIColor.blackColor()
        cityTextField.placeholder = "Where are you visiting?"

//        let str = NSAttributedString(string: cityTextField.placeholder, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
//        cityTextField.attributedPlaceholder = str
        return cityTextField
    }()
    
    public lazy var textField1: UITextView = {
        let textField1 = UITextView()
        textField1.translatesAutoresizingMaskIntoConstraints = false;
        textField1.delegate = self
        textField1.textColor = UIColor.blackColor()
        textField1.font = UIFont(name: "AvenirNext-Regular", size: 16)
        return textField1
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    var thissize : CGSize?
    var cgvos : CGPoint?
    
    init(items: [NSManagedObject], size: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        thissize = size
        
        thisitems = items
        
        self.addSubview(scrollView)
        scrollView.sizeToWidth((thissize?.width)!)
        scrollView.sizeToHeight((thissize?.height)! * 2)
        scrollView.pinToEdgesOfSuperview()
        
        let item = items[0]
        title.text = item.valueForKey("name") as? String
        
        self.addSubview(title)
        self.addSubview(cityTextField)
        self.addSubview(textField1)
        self.addSubview(nextButton)
        self.addSubview(plusButton)
        
        self.createLayout()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.addGestureRecognizer(tap)
    }
    
    func createLayout() {
        cityTextField.pinToLeftEdgeOfSuperview(offset: 40)
        cityTextField.pinToTopEdgeOfSuperview(offset: 50)
        
        title.pinToLeftEdgeOfSuperview(offset: 40)
        title.positionBelowItem(cityTextField, offset: 20)
        title.sizeToWidth(thissize!.width - 50)
        
        textField1.pinToLeftEdgeOfSuperview(offset: 40)
        textField1.positionBelowItem(title, offset: 20)
        textField1.sizeToWidth(thissize!.width - 50)
        textField1.sizeToHeight(100)
        
        nextButton.positionBelowItem(textField1, offset: 20)
        nextButton.pinToLeftEdgeOfSuperview(offset: 40)
        nextButton.sizeToWidth(200)
        nextButton.sizeToHeight(50)
        
        plusButton.positionToTheLeftOfItem(textField1, offset: 10)
        plusButton.positionBelowItem(title, offset: 25)
    }
    
    func plusPressed() {
        plusButton.enabled = false
        
        textField1.becomeFirstResponder()
    }
    
    func nextPressed() {
        if (count < 4) {
            count++
        }
        else {
            // save journal entry and move forward to create + show journal entry
        }
        let item = thisitems[count]
        
        title.fadeTransition(0.4)
        title.text = item.valueForKey("name") as? String
        
        textField1.text = ""
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        cgvos = scrollView.contentOffset
        var pt : CGPoint
        var rc = textField.bounds
        rc = textField.convertRect(rc, toView: scrollView)
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
        scrollView.setContentOffset(pt, animated: true)
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        scrollView.setContentOffset(cgvos!, animated: true)
        textField.resignFirstResponder()
        return true
    }
    
}
