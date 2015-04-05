//
//  SelectImageViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit
import AssetsLibrary

class SelectImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeght: NSLayoutConstraint!
    
    var inputImage: UIImage!
    
    var _textRecogniser: SNTextRecogniser!
    var textRecogniser: SNTextRecogniser {
        get {
            if _textRecogniser == nil {
                _textRecogniser = SNTextRecogniser()
            }
            return _textRecogniser
        }
    }
    
    var _assetsLibrary: ALAssetsLibrary!
    var assetsLibrary: ALAssetsLibrary {
        get {
            if _assetsLibrary == nil {
                _assetsLibrary = ALAssetsLibrary()
            }
            return _assetsLibrary
        }
    }
    var isLoading = false
    let loadingLimit = 20
    var assetsURLs: [NSURL]!
    var thumbnails: [UIImage]!
    var photoGroupAssetURL: NSURL!
    
    var imagesDirectory: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        }
    }
    var imagesCount: Int {
        return NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.imagesDirectory, error: nil)!.count
    }
    
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
//    }
//    
//    override func shouldAutorotate() -> Bool {
//        return false
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select"
        self.imageView.image = inputImage
        
        //loading existed images from the assets
        var thumbnails: [UIImage] = []
        self.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) -> Void in
            if group != nil {
                self.photoGroupAssetURL = group!.valueForProperty(ALAssetsGroupPropertyURL) as NSURL?
                stop.initialize(true)
                self.loadNextPortionOfImages()
            }
        }) { (error) -> Void in

        }
        
        self.collectionView.registerNib(PhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier())
        
        let barButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didPressNextButton:"))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @IBAction func didPanGestireRecogniser(sender: UIPanGestureRecognizer) {
        var value = self.view.height - sender.locationInView(self.view).y
        if (value < 100) {
            value = 100
        }
        else if value > 200 && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            value = 200
        }
        else if value > 500 && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            value = 500
        }
        self.collectionHeght.constant = value
    }
    
    func loadNextPortionOfImages() {
        if photoGroupAssetURL == nil || isLoading {
            return
        }
        isLoading = true
        self.assetsLibrary.groupForURL(photoGroupAssetURL, resultBlock: { (savedPhotoGroup) -> Void in
            let imagesCount = savedPhotoGroup?.numberOfAssets() ?? 0
            let currentOffset = self.thumbnails == nil ? 0 : self.thumbnails!.count
            let lowerBound = max(imagesCount - currentOffset - self.loadingLimit, 0)
            let indexSet = NSIndexSet(indexesInRange:NSMakeRange(lowerBound, min(imagesCount - currentOffset, self.loadingLimit)))
            var assetsURLsArray: [NSURL] = []
            var thumbnailsArray: [UIImage] = []
            var indexPaths: [NSIndexPath] = []
            
            savedPhotoGroup?.enumerateAssetsAtIndexes(indexSet, options: NSEnumerationOptions.Reverse, usingBlock: { (alAsset, index, stop) -> Void in
                if alAsset != nil {
                    indexPaths.append(NSIndexPath(forItem: index - lowerBound + currentOffset, inSection: 0))
                    assetsURLsArray.append(alAsset!.valueForProperty(ALAssetPropertyAssetURL) as NSURL)
                    let assetThumbnail = UIImage(CGImage: alAsset.thumbnail().takeUnretainedValue())
                    thumbnailsArray.append(assetThumbnail!)
                    
                    if index == lowerBound {
                        if self.thumbnails == nil {
                            self.thumbnails = thumbnailsArray
                            self.assetsURLs = assetsURLsArray
                        } else {
                            self.thumbnails.extend(thumbnailsArray)
                            self.assetsURLs.extend(assetsURLsArray)
                        }
                        self.isLoading = false
                        self.collectionView.insertItemsAtIndexPaths(indexPaths)
                    }
                }
            })
        }) { (error) -> Void in
            
        }
    }
    
    func enumerateGroup(group: ALAssetsGroup!, completion: ([UIImage], [NSURL]) -> Void ) {
        var assetsURLsArray: [NSURL] = []
        var thumbnailsArray: [UIImage] = []
        
        group?.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (alAsset, index, innerStop) -> Void in
            if alAsset != nil {
                assetsURLsArray.append(alAsset!.valueForProperty(ALAssetPropertyAssetURL) as NSURL)
                let assetThumbnail = UIImage(CGImage: alAsset.thumbnail().takeUnretainedValue())
                thumbnailsArray.append(assetThumbnail!)
                if assetsURLsArray.count == self.loadingLimit {
                    innerStop.initialize(true)
                    completion(thumbnailsArray, assetsURLsArray)
                }
            }
            else {
                completion(thumbnailsArray, assetsURLsArray)
            }
        })
    }
    
    func didPressNextButton(sender: AnyObject) {
        if self.imageView.image == nil {
            UIAlertView(title: "Error", message: "Please choose image", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        hud.labelText = "Processing"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.textRecogniser.recogniseTextFromImage(self.imageView.image!, completion: { (text) -> (Void) in
                hud.hide(true)
                self.performSegueWithIdentifier("ShowDetailsSegue", sender: [self.imageView.image!, text])
            })
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailsSegue" {
            let dvc = segue.destinationViewController as SnapDetailsViewController
            let parameters = sender as [AnyObject]
            dvc.snapImage = parameters.first as UIImage
            dvc.snapText = parameters.last as String
        }
    }
    
    private func loadImageAtIndex(index: Int) {
        let assetURL = assetsURLs![index]
        self.assetsLibrary.assetForURL(assetURL, resultBlock: { (asset) -> Void in
            if asset != nil { // image wasn't deleted by user
                self.imageView.image = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!
            }
            }) { (error) -> Void in
                
        }
    }
    
    //MARK: - Collection View Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails == nil ? 0 : thumbnails!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && indexPath.row > thumbnails!.count - 5 {
            loadNextPortionOfImages()
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.identifier(), forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageView.image = thumbnails![indexPath.item]
        if self.imageView.image == nil && indexPath.item == 0 { // we don't have an selected image
            loadImageAtIndex(0)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        loadImageAtIndex(indexPath.item)
    }
}
