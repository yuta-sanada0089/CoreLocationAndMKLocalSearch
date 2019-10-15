//
//  RatingCell.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/15.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit
import Cosmos

class RatingCell: UITableViewCell {
	@IBOutlet weak var titleTextLabel: UILabel!
	@IBOutlet weak var consmosView: CosmosView!
	@IBOutlet weak var ratingValueLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.titleTextLabel.text = ""
		self.consmosView.settings.fillMode = .full
		self.ratingValueLabel.text = "0.0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
	func setContent(title: String) {
		self.titleTextLabel.text = title
	}
}
