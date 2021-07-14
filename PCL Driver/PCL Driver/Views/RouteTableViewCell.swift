//
//  RouteTableViewCell.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet var isselected: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var distance: UILabel!

    @IBOutlet var address: UILabel!
    @IBOutlet var customerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
