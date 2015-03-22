//
//  SnapsViewTableViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SnapsViewTableViewController: UITableViewController, UISearchDisplayDelegate {
    
    var _snaps: [SNSnap]!
    var snaps: [SNSnap] {
        get {
            if _snaps == nil {
                if _searchText == nil || _searchText!.isEmpty {
                    _snaps = SNSnap.MR_findAll() as [SNSnap]
                }
                else {
                    _snaps = SNSnap.MR_findAllWithPredicate(NSPredicate(format: "title CONTAINS[cd] %@ OR tags CONTAINS[cd] %@ OR email CONTAINS[cd] %@", _searchText!, _searchText!, _searchText!)) as [SNSnap]
                }
            }
            return _snaps
        }
    }
    
    var _searchText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(SnapTableViewCell.nib(), forCellReuseIdentifier: SnapTableViewCell.identifier())
        self.title = "Snapps"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSnap" {
            let dvc = segue.destinationViewController as SnapDetailsViewController
            dvc.inputSnap = sender as SNSnap
        }
    }

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snaps.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SnapTableViewCell.identifier(), forIndexPath: indexPath) as SnapTableViewCell
        cell.configureWithSnap(self.snaps[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectSelectedRow()
        self.performSegueWithIdentifier("ShowSnap", sender: self.snaps[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let snap = self.snaps[indexPath.row]
        snap.MR_deleteEntity()
        MagicalRecord.saveUsingCurrentThreadContextWithBlockAndWait(nil)
        _snaps.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // MARK: - Search Table Delegate Methods
    func searchDisplayController(controller: UISearchDisplayController, didLoadSearchResultsTableView tableView: UITableView) {
        tableView.registerNib(SnapTableViewCell.nib(), forCellReuseIdentifier: SnapTableViewCell.identifier())
        tableView.rowHeight = self.tableView.rowHeight
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        _searchText = searchString
        _snaps = nil
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, didHideSearchResultsTableView tableView: UITableView) {
        _snaps = nil
        _searchText = nil
        self.tableView.reloadData()
    }
}
