//
//  CustomTableViewCell.swift
//  tableViewTest
//
//  Created by Денис on 27.03.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTextLabel: UILabel!
    @IBOutlet weak var eventDoneLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
