//
//  CarListTableViewController.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/12/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

public final class CarListTableViewController: UITableViewController, CoreDataCompatible {

    private var objects = [AnyObject]()
    public var coreDataStack: CoreDataStack!

    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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




