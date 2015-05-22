//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by User on 5/15/15.
//  Copyright (c) 2015 Neural Health Systems. All rights reserved.
//

import Foundation

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    //Declare memes and set to transition file in AppDelegate
    
    var memes:[Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tabBarController?.tabBar.hidden = false
        self.collectionView.reloadData()
    }
    
  // Add Button, Switch to Meme Editor  
    
    @IBAction func memeEditor(sender: UIBarButtonItem) {
        
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! ViewController
        presentViewController(memeEditorController, animated: true, completion: nil)
        
        }
    
    
   // MARK: Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.nameLabel.text = meme.textTop
        cell.memeImageView.image = meme.memedImage
        cell.detailLabel.text = meme.textBottom
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
