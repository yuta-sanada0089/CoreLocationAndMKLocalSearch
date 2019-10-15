//
//  ViewController.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/11.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	enum PostReviewCellType: Int, CaseIterable {
		case contents
		case rating
		case location
		case reviewItem
		case postFacebook
		case postTwitter
		case debug
		
		var title: String {
			switch self {
			case .contents:
				return ""
			case .rating:
				return "全体的な評価"
			case .location:
				return "位置情報を追加"
			case .reviewItem:
				return "何の商品のレビューですか"
			case .postFacebook:
				return "Facebook"
			case .postTwitter:
				return "Twitter"
			case .debug:
				return "デバック"
			}
		}
	}
	
	private var textView: ExTextView? = nil
	
	private var ratingValue: Double = 0.0
	
	private var isFacebook = false
	
	private var isTwitter = false
	
	private var isSelectedReward = true

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
		self.tableView.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
		self.tableView.register(UINib(nibName: "ReviewRewardCell", bundle: nil), forCellReuseIdentifier: "ReviewRewardCell")
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.tableFooterView = UIView(frame: .zero)
	}
	
	private func setTextField(textView: ExTextView) {
		self.textView = textView
	}
	
	private func setSwitchCell(cellType: PostReviewCellType?, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = cellType?.title
		cell.textLabel?.font = UIFont.hiraginoFont(ofSize: 14.0)
		let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		switchView.onTintColor = .blue
		switchView.isOn = false
		switchView.tag = indexPath.row
		if cellType == .postFacebook {
			switchView.addTarget(self, action: #selector(postFacebookTriggered), for: .valueChanged)
		} else {
			switchView.addTarget(self, action: #selector(postTwitterTriggered), for: .valueChanged)
		}
		cell.accessoryView = switchView
		return cell
	}
	
	// facebookのSwitchの値が変更された時のイベント
	@objc private func postFacebookTriggered(sender: UISwitch){
		self.isFacebook = sender.isOn
    }
	// TwitterのSwitchの値が変更された時のイベント
	@objc private func postTwitterTriggered(sender: UISwitch){
		self.isTwitter = sender.isOn
    }
	
	// 選択中のRewardをリセットするイベント
	@objc private func removeSelectedReward() {
		self.isSelectedReward = false
		let row = IndexPath(row: PostReviewCellType.reviewItem.rawValue, section: 0)
		tableView.reloadRows(at: [row], with: .none)
	}

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return PostReviewCellType.allCases.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let type = PostReviewCellType(rawValue: indexPath.row)
		switch type {
		case .contents:
			let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
			guard let textView = cell.textView else { return cell }
			self.setTextField(textView: textView)
			return cell
		case .rating:
			let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
			guard let title = type?.title else { return cell }
			cell.setContent(title: title)
			cell.consmosView.didTouchCosmos = { rating in
				self.ratingValue = rating
				cell.ratingValueLabel.text = "\(rating)"
			}
			return cell
		case .location:
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			cell.textLabel?.text = type?.title
			cell.textLabel?.font = UIFont.hiraginoFont(ofSize: 14.0)
			cell.accessoryType = .disclosureIndicator
			return cell
		case .reviewItem:
			if !isSelectedReward {
				let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
				cell.textLabel?.text = type?.title
				cell.textLabel?.font = UIFont.hiraginoFont(ofSize: 14.0)
				cell.accessoryType = .disclosureIndicator
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewRewardCell", for: indexPath) as! ReviewRewardCell
				let url = "https://dev-stat.image.timebank.jp/service_pictures/high_6d7e206c-bfd1-4b33-b188-9724fa995e99.jpg"
				let title = "焼鳥など6品＋飲み放題150分✨中華料理世界大会で金賞を受賞した『焼鳥×中華』【六本木駅徒歩2分】"
				cell.setContent(imageUrl: url, title: title)
				cell.deleteButton.addTarget(self, action: #selector(removeSelectedReward), for: .allTouchEvents)
				return cell
			}
		case .postFacebook:
			return setSwitchCell(cellType: type, indexPath: indexPath)
		case .postTwitter:
			return setSwitchCell(cellType: type, indexPath: indexPath)
		case .debug:
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			cell.textLabel?.text = type?.title
			cell.textLabel?.font = UIFont.hiraginoFont(ofSize: 14.0)
			cell.accessoryType = .disclosureIndicator
			return cell
		case .none:
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			return cell
		}
	}
	
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard let type = PostReviewCellType(rawValue: indexPath.row) else { return }
		if type == .debug {
			print("\(self.textView?.text ?? "nothing")")
			print("isFacebook: \(self.isFacebook)")
			print("isTwitter: \(self.isTwitter)")
		}
		
		if type == .location {
			
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let type = PostReviewCellType(rawValue: indexPath.row) else { return 60.0 }
		switch type {
		case .contents:
			return 129.0
		default:
			return 60.0
		}
	}
}

