//
//  CarListTableViewController.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/12/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

public final class CarListTableViewController: UITableViewController, CoreDataCompatible {

    // MARK: - Properties
    
    private var objects = [AnyObject]()
    private let locationManager = CLLocationManager()
    private var headerView: UIView?
    private var tableHeaderHeight: CGFloat = 0
    private var fetchResultController: NSFetchedResultsController?
    
    // MARK: - CoreDataCompatible
    
    public var coreDataStack: CoreDataStack!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchResultsController()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        do {
            try fetchResultController?.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch data")
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
    
    private func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func prepareCarDetailsSegue(segue: UIStoryboardSegue) {
        // TODO: Add Implementation
    }
    
    private func prepareAddCarSegue(segue: UIStoryboardSegue) {
        var destinationController = segue.destinationViewController as! CoreDataCompatible
        destinationController.coreDataStack = coreDataStack
    }
    
    private func updateWeatherUI(withWeatherData data: Weather) {
        if let temperature = data.temperature,
            city = data.city {
            temperatureLabel.text = "+\(temperature)"
            cityLabel.text = city
        }
    }
    
    private func setupFetchResultsController() {
        let request = NSFetchRequest(entityName: Car.entityName)
        
        request.sortDescriptors = []
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController?.delegate = self
    }

}

// MARK: - UITableViewDataSource

extension CarListTableViewController {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.fetchedObjects?.count ?? 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CarCell.identifier, forIndexPath: indexPath) as! CarCell
        if let car = fetchResultController?.objectAtIndexPath(indexPath) as? Car {
            cell.model = car
        }
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
            guard let car = fetchResultController?.objectAtIndexPath(indexPath) as? Car else { return }
            coreDataStack.managedObjectContext.deleteObject(car)
            coreDataStack.saveContext()
        }
    }
}

extension CarListTableViewController: NSFetchedResultsControllerDelegate {
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
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
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // def location - Kiev
        Weather.getForecast(["lat" : 50.43, "lon" : 30.52], completion: { [weak self] (item) in
            guard let strongSelf = self else { return }
            guard let weather = item as? Weather else { return }
            strongSelf.updateWeatherUI(withWeatherData: weather)
        }) { (error) in
            
        }
    }
    
}




