//
//  newJournalEditView.swift
//  list
//
//  Created by Robin Mehta on 12/26/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit
import CoreData

public class NewJournalEditView: UIView, UITextFieldDelegate {

    public lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.numberOfLines = 0
        title.text = "Where are you visiting?"
        title.textColor = UIColor.grayColor()
        title.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        title.textAlignment = .Center
        return title
    }()
    
    public lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.translatesAutoresizingMaskIntoConstraints = false;
        cityTextField.delegate = self
        cityTextField.placeholder = "City, State, or Country"
        return cityTextField
    }()
    
    var thissize : CGSize?
    
    init(items: [NSManagedObject], size: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        thissize = size
        
        self.addSubview(title)
        self.addSubview(cityTextField)
        
        self.createLayout()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.addGestureRecognizer(tap)
    }
    
    func createLayout() {
        title.centerHorizontallyInSuperview()
        title.pinToTopEdgeOfSuperview(offset: 50)
        
        cityTextField.centerHorizontallyInSuperview()
        cityTextField.positionBelowItem(title, offset: 20)
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
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}
