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
    
    var inputImage: UIImage!
    
    var _assetsLibrary: ALAssetsLibrary!
    var assetsLibrary: ALAssetsLibrary {
        get {
            if _assetsLibrary == nil {
                _assetsLibrary = ALAssetsLibrary()
            }
            return _assetsLibrary
        }
    }
    let loadingLimit = 20
    var assetsURLs: [NSURL]!
    var thumbnails: [UIImage]!
    var imagesDirectory: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        }
    }
    var imagesCount: Int {
        return NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.imagesDirectory, error: nil)!.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select"
        self.imageView.image = inputImage
        
        //loading existed images from the assets
        var thumbnails: [UIImage] = []
        self.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) -> Void in
            self.enumerateGroup(group, completion: { (thumbsArr, urlsArr) -> Void in
                if self.thumbnails == nil {
                    self.thumbnails = thumbsArr
                    self.assetsURLs = urlsArr
                }
                else {
                    self.thumbnails.extend(thumbsArr)
                    self.assetsURLs.extend(urlsArr)
                }
                self.collectionView.reloadData()
                UIImageWriteToSavedPhotosAlbum(self.inputImage, nil, nil, nil)
            })
        }) { (error) -> Void in
            UIImageWriteToSavedPhotosAlbum(self.inputImage, nil, nil, nil)
        }
        
        self.collectionView.registerNib(PhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier())
        
        let barButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didPressNextButton:"))
        self.navigationItem.rightBarButtonItem = barButton
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
        self.performSegueWithIdentifier("ShowDetailsSegue", sender: self.imageView.image)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "ShowDetailsSegue" {
            return self.imageView.image != nil
        }
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailsSegue" {
            let dvc = segue.destinationViewController as SnapDetailsViewController
            dvc.snapImage = sender as UIImage
        }
    }
    
    //MARK: - Collection View Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (thumbnails == nil ? 0 : thumbnails!.count) + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.identifier(), forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageView.image = indexPath.item == 0 ? inputImage : thumbnails![indexPath.item - 1]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            self.imageView.image = inputImage
        }
        else {
            let assetURL = assetsURLs![indexPath.item - 1]
            self.assetsLibrary.assetForURL(assetURL, resultBlock: { (asset) -> Void in
                self.imageView.image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!
                }) { (error) -> Void in
                    
            }
        }
    }
}
