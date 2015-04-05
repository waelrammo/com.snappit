//
//  StoreTableViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class StoreTableViewController: UITableViewController {
    
    @IBOutlet weak var snapsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.snapsLabel.text = NSString(format: "%d snaps", SNSnap.snapCount())
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectSelectedRow()
    }
}
