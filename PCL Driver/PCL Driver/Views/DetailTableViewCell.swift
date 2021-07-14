//
//  DetailTableViewCell.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var RouteName: UILabel!
    @IBOutlet var RouteNumber: UILabel!
    @IBOutlet var Vehicle: UILabel!
    @IBOutlet var customers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
