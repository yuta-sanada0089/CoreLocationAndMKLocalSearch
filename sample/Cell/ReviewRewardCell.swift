//
//  ReviewRewardCell.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/15.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewRewardCell: UITableViewCell {

	@IBOutlet weak var rewardImage: UIImageView!
	@IBOutlet weak var rewardTitleLabel: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        self.rewardImage.image = nil
		self.rewardTitleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setContent(imageUrl: String, title: String) {
		if let url = URL(string: imageUrl) {
			self.rewardImage.sd_setImage(with: url, placeholderImage: UIImage(named: "no_img_default"))
		}
		self.rewardTitleLabel.text = title
	}
    
}
