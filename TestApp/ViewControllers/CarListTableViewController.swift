//
//  CarListTableViewController.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/12/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import CoreLocation

public final class CarListTableViewController: UITableViewController, CoreDataCompatible {

    // MARK: - Properties
    
    private var objects = [AnyObject]()
    private let locationManager = CLLocationManager()
    private var headerView: UIView?
    private var tableHeaderHeight: CGFloat = 0
    
    // MARK: - CoreDataCompatible
    
    public var coreDataStack: CoreDataStack!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setStretchyHeader()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Segues

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case UIStoryboardSegue.Main.addCarSegue:
            prepareAddCarSegue(segue)
        case UIStoryboardSegue.Main.carDetailsSegue:
            prepareCarDetailsSegue(segue)
        default:
            break
        }
    }
    
    // MARK: - Private Methods 
    
    private func prepareCarDetailsSegue(segue: UIStoryboardSegue) {
        // TODO: Add Implementation
    }
    
    private func prepareAddCarSegue(segue: UIStoryboardSegue) {
        var destinationController = segue.destinationViewController as! CoreDataCompatible
        destinationController.coreDataStack = coreDataStack
    }
    
    private func setStretchyHeader() {
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        guard let headerView = headerView else { return }
        
        tableView.addSubview(headerView)
        tableHeaderHeight = headerView.frame.height
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPointMake(0, -tableHeaderHeight)
        
        updateHeaderView()
    }
    
    private func updateHeaderView() {
        guard let headerView = headerView else { return }
        
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    private func updateWeatherUI(withWeatherData data: Weather) {
        if let temperature = data.temperature,
            city = data.city {
            temperatureLabel.text = "+\(temperature)"
            cityLabel.text = city
        }
    }

}

// MARK: - UITableViewDataSource

extension CarListTableViewController {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CarCell", forIndexPath: indexPath)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CarListTableViewController {
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension CarListTableViewController: CLLocationManagerDelegate {
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations.first!
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        Weather.getForecast(["lat" : lat, "lon" : long], completion: { [weak self] (item) in
            guard let strongSelf = self else { return }
            guard let weather = item as? Weather else { return }
            strongSelf.updateWeatherUI(withWeatherData: weather)
            }) { (error) in
                
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CarListTableViewController {
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}




