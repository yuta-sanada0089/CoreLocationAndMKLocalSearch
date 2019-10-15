//
//  ExTextView.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/12.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit

protocol ExTextViewDelegate: AnyObject {
	func textViewDidChange(_ textView: UITextView)
}

@IBDesignable
class ExTextView: UITextView {

	@IBInspectable
	public var placeholderText: String = "" {
		didSet {
			self.placeholderLabel.text = placeholderText
		}
	}
	
	@IBInspectable
	public var isNeedSelfSizing: Bool = false
	
	private var preferredMaxLayoutWidth: CGFloat? {
		didSet {
			if self.preferredMaxLayoutWidth != oldValue {
				self.invalidateIntrinsicContentSize()
			}
		}
	}
	
	override var intrinsicContentSize: CGSize {
		guard self.isNeedSelfSizing, self.isScrollEnabled, let width = self.preferredMaxLayoutWidth else {
			return super.intrinsicContentSize
		}
		return self.textSize(for: width)
	}
	
	private var placeholderLabel: UILabel!
	
	var maximumCharacterLimit: Int?
	weak var exDelegate: ExTextViewDelegate?
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
		
        self.initialize()
    }
    
    func initialize() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 40.0))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonAction(_:)))
        
        toolBar.items = [space, doneButton]
        self.inputAccessoryView = toolBar
		
		// Placeholder
		self.placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
		self.placeholderLabel.textAlignment = .left
		self.placeholderLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
		self.placeholderLabel.textColor = UIColor.lightGray
		self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.placeholderLabel)
		
		let views: [String: Any] = ["placeholder": self.placeholderLabel as Any]
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[placeholder]-4-|", options: .alignAllCenterX, metrics: nil, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[placeholder]", options: .alignAllTop, metrics: nil, views: views))
		
		self.delegate = self
    }

	override func layoutSubviews() {
		super.layoutSubviews()
		
		if let placeholderLabel = self.placeholderLabel {
			placeholderLabel.isHidden = self.text.count > 0
		}
		
		if self.isNeedSelfSizing {
			self.preferredMaxLayoutWidth = bounds.size.width
		}
	}
	
	// MARK: - Placeholder
	
	/// ExTextViewに内容が無い場合に見せるplaceholderを設定
	/// - parameter placeholder: placeholderのテキスト
	func setPlaceholder(_ placeholder: String) {
//		if self.placeholderLabel == nil {
//			self.placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//			self.placeholderLabel.textAlignment = .left
//			self.placeholderLabel.font = self.font
//			self.placeholderLabel.textColor = UIColor.lightGray
//			self.addSubview(self.placeholderLabel)
//
//			self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[placeholderLabel]-6-|", options: .alignAllCenterX, metrics: nil, views: ["placeholderLabel":self.placeholderLabel]))
//			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[placeholderLabel]", options: .alignAllCenterY, metrics: nil, views: ["placeholderLabel":self.placeholderLabel]))
//
//			self.delegate = self
//		}
		if let label = self.placeholderLabel {
			label.isEnabled = true
			label.text = placeholder
		}
	}
	
	func setPlaceHolderTextSize(size: CGFloat) {
		if let label = self.placeholderLabel {
			label.font = UIFont(name: "HelveticaNeue-Light", size: size)
		}
	}
	
	// MARK: - Characters Counting
	
	func setCharacterCount(_ isEnable: Bool) {
	}
	
	func textSize(for width: CGFloat) -> CGSize {
		let containerSize = CGSize(width: width - textContainerInset.horizontal,
								   height: CGFloat.greatestFiniteMagnitude)
		let container = NSTextContainer(size: containerSize)
		container.lineFragmentPadding = textContainer.lineFragmentPadding
		let storage = NSTextStorage(attributedString: attributedText)
		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(container)
		storage.addLayoutManager(layoutManager)
		layoutManager.glyphRange(for: container)
		let rawSize = layoutManager.usedRect(for: container).size
		let calculatedSize = CGSize(width: ceil(rawSize.width + textContainerInset.horizontal), height: ceil(rawSize.height + textContainerInset.vertical))
		
		return calculatedSize
	}
	
	// MARK: - Action
	
    @objc func doneButtonAction(_ sender: Any) {
        if let view = self.delegate as? UIView {
            view.endEditing(true)
        } else if let viewController = self.delegate as? UIViewController {
            viewController.view.endEditing(true)
        }
    }
}

extension ExTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if let placeholderLabel = self.placeholderLabel {
			placeholderLabel.isHidden = self.text.count > 0
		}
		
		if let delegate = self.exDelegate {
			delegate.textViewDidChange(textView)
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if let limit = self.maximumCharacterLimit {
			let currentText = textView.text ?? ""
			guard let stringRange = Range(range, in: currentText) else { return false }
			let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
			return updatedText.count <= limit
		} else {
			return true
		}
	}
}

