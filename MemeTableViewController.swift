//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by User on 5/15/15.
//  Copyright (c) 2015 Neural Health Systems. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource {

    
    // Declare memes and set to transition file in AppDelegate
    var memes: [Meme]!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        
        self.tableView.reloadData()
        
    }
    
    // Check Memes Sent at start up, if 0 switch to Meme Editor
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if memes.count == 0 {
            
            let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! ViewController
            presentViewController(memeEditorController, animated: true, completion: nil)
            
        }

    }
    
    // Add Button, Switch to Meme Editor

    @IBAction func memeEditor(sender: UIBarButtonItem) {
        
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! ViewController
        presentViewController(memeEditorController, animated: true, completion: nil)
        
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.textTop
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.textBottom
        }
        
        return cell
    }
    
    // If the cell has a detail label, put bottom text into it
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
