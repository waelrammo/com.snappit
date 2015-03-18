//
//  SnapsViewTableViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SnapsViewTableViewController: UITableViewController {
    
    var _snaps: [SNSnap]!
    var snaps: [SNSnap] {
        get {
            if _snaps == nil {
                _snaps = SNSnap.savedSnaps()
            }
            return _snaps
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Snapps"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSnap" {
            let dvc = segue.destinationViewController as SnapDetailsViewController
            let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
            dvc.inputSnap = self.snaps[indexPath!.row] as SNSnap
        }
    }

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snaps.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("snapCell", forIndexPath: indexPath) as SnapTableViewCell
        cell.configureWithSnap(snaps[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectSelectedRow()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let snap = snaps[indexPath.row]
        snap.remove()
        _snaps = nil
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
