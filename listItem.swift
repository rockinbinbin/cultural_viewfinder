//
//  listItem.swift
//  list
//
//  Created by Robin Mehta on 12/11/15.
//  Copyright © 2015 robin. All rights reserved.
//

import UIKit

class listItem: UITableViewCell {
    
    public lazy var companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.translatesAutoresizingMaskIntoConstraints = false;
        companyLabel.numberOfLines = 0
        companyLabel.textColor = UIColor.grayColor()
        companyLabel.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        self.contentView.addSubview(companyLabel)
        return companyLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        companyLabel.centerInSuperview()
    }

}
