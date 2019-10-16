//
//  SearchLocationViewController.swift
//  sample
//
//  Created by Sanada Yuta on 2019/10/15.
//  Copyright © 2019 Sanada Yuta. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchLocationViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	var mapItems: [MKMapItem]? = nil
	
	var locationManager: CLLocationManager!
	override func viewDidLoad() {
        super.viewDidLoad()
		initializeLocationManager()
		requestAuthorization()
        setupLocationManager()
    }
	
	fileprivate func initializeLocationManager() {
        locationManager = CLLocationManager()
    }

    fileprivate func requestAuthorization() {
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
    }
	
	private func setupLocationManager() {
		// 位置情報取得の許可のステータス
		let status = CLLocationManager.authorizationStatus()
		// 常に許可もしくはアプリ使用時のみ許可の場合
		if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.distanceFilter = 100
            locationManager.startUpdatingLocation()
        }
    }
	
	private func searchMKMapItem(region: MKCoordinateRegion) {
		let request = MKLocalSearch.Request()
		request.region = region
		MKLocalSearch(request: request).start { (response, error) in
//            if let error = error {
//
//                return
//            }
			self.mapItems = response?.mapItems
        }
	}
}

extension SearchLocationViewController: CLLocationManagerDelegate {
	// 位置情報の取得に失敗した時に呼ばれる
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
	//位置情報の取得・更新の度に呼ばれる
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// 取得した位置情報の緯度経度
		let location = locations.first
		guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else { return }
		let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
		let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100.0, longitudinalMeters: 100.0) // 100m * 100km
		searchMKMapItem(region: region)
	}
}

extension MKPlacemark {
    var address: String {
        let components = [self.administrativeArea, self.locality, self.thoroughfare, self.subThoroughfare]
        return components.compactMap { $0 }.joined(separator: "")
    }
}
