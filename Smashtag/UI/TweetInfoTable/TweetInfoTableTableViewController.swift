//
//  TweetInfoTableTableViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 02/10/2017.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetInfoTableTableViewController: UITableViewController {
    var tweetInfoModel: TweetInfoModel? {
        didSet {
            if tweetInfoModel != nil {
                tweetInfoCellFactory = TweetInfoCellFactory(tweetInfoModel: tweetInfoModel!)
            }
            self.tableView.reloadData()
        }
    }
    private var tweetInfoCellFactory: TweetInfoCellFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetInfoModel?.sectionsNumber ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetInfoModel?.numberOfRows(inSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetInfoModel?.title(forSection: section) ?? ""
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tweetInfoModel != nil,
            tweetInfoModel!.sectionsNumber > indexPath.section,
            let objectToShow = tweetInfoModel!.object(forRow: indexPath.row, inSection: indexPath.section),
            let sectionType = tweetInfoModel!.type(forSection: indexPath.section),
            sectionType == .MediaSection,
            let media = objectToShow as? Twitter.MediaItem
        else {
            return UITableViewAutomaticDimension
        }
        let rowRect = tableView.bounds
        return rowRect.width / CGFloat(media.aspectRatio)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tweetInfoCellFactory != nil else {
            return UITableViewCell()
        }
        return tweetInfoCellFactory!.createTweetInfoCell(forRow: indexPath.row, inSection: indexPath.section, inTableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tweetInfoModel != nil,
            tweetInfoModel!.sectionsNumber > indexPath.section,
            let objectToShow = tweetInfoModel!.object(forRow: indexPath.row, inSection: indexPath.section),
            let sectionType = tweetInfoModel!.type(forSection: indexPath.section),
            sectionType != .MediaSection,
            let mention = objectToShow as? Twitter.Mention
        else {
            return
        }
        if sectionType == .URLsSection {
            if let url = URL(string: mention.keyword) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            //[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmashTweetTableViewControllerID")
            if let tweetsVC = vc as? SmashTweetTableViewController {
                tweetsVC.searchText = mention.keyword
                navigationController?.pushViewController(tweetsVC, animated: true)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageViewSegueID" {
            if let tweetMediaImageTVC = segue.destination as? TweetMediaImageViewController,
                let cell = sender as? TweetInfoMediaTableViewCell
            {
                tweetMediaImageTVC.mediaImage = cell.mediaImageView.image
            }
        }
    }
}


