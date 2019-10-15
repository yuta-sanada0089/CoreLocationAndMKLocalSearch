//
//  UIFontExtension.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/15.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit

extension UIFont {
	static func hiraginoFont(ofSize: CGFloat) -> UIFont {
		return UIFont(name: "HiraginoSans-W3", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
	}
	
	static func boldHiraginoFont(ofSize: CGFloat) -> UIFont {
		return UIFont(name: "HiraginoSans-W6", size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
	}
}
