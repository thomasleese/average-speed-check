//
//  ViewController.swift
//  Average Speed Check
//
//  Created by Thomas Leese on 07/09/2016.
//  Copyright © 2016 Thomas Leese. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?

    var timer: Timer?

    var currentSpeed: Double = 0
    var totalSpeed: Double = 0
    var totalSpeedCount: Int = 0

    @IBOutlet weak var label: UILabel!

    func startLocationServices() {
        locationManager = CLLocationManager()

        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 2

        locationManager?.requestWhenInUseAuthorization()

        locationManager?.startUpdatingLocation()

        print("Started recording locations.")
    }

    func stopLocationServices() {
        locationManager?.stopUpdatingLocation()

        print("Stopped recording locations.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startLocationServices()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateLabel), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopLocationServices()

        timer?.invalidate()
    }

    func metersPerSecondToMilesPerHour(_ value: Double) -> Double {
        return value * 2.23694
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!

        let speed = location.speed

        if speed != -1 {
            currentSpeed = speed
        }

        print("Got current speed as:", currentSpeed)
    }

    func updateLabel() {
        totalSpeed += currentSpeed
        totalSpeedCount += 1

        let averageSpeedMps = totalSpeed / Double(totalSpeedCount)
        let averageSpeed = metersPerSecondToMilesPerHour(averageSpeedMps)

        label.text = String(format: "%.1f", averageSpeed) + " mph"
    }

}
