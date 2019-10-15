//
//  UIEdgeInsetsExtension.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/12.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
	
	internal var vertical: CGFloat {
		return top + bottom
	}
	
	internal var horizontal: CGFloat {
		return left + right
	}
	
}
