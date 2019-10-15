//
//  TableViewCell.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/11.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

	@IBOutlet weak var sampleImage: UIImageView!
	@IBOutlet weak var textView: ExTextView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.textView.text = ""
		self.textView.setPlaceHolderTextSize(size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setContent(image: UIImage) {
		self.sampleImage.image = image
	}
    
}
