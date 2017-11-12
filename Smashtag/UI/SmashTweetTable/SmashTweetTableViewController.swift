//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/15/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController
{
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        container?.performBackgroundTask { /*[weak self]*/ context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                // bad way to count
                let tweetRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(tweetRequest))?.count {
                    print("\(tweetCount) tweets")
                }
                // good way to count
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        switch segueIdentifier {
        case "Tweeters Mentioning Search Term":
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        case "TweetInfoSegueIdentificator":
            if let tweetInfoTVC = segue.destination as? TweetInfoTableTableViewController,
                let cell = sender as? TweetTableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                tweets.count > indexPath.section,
                tweets[indexPath.section].count > indexPath.row
            {
                let tweet = tweets[indexPath.section][indexPath.row]
                tweetInfoTVC.tweetInfoModel = TweetInfoModel(for: tweet)
                dependencyInjector?.inject(to: tweetInfoTVC)
            }
        case "TweetPicturesSegueID":
            if let tweetPicturesVC = segue.destination as? TweetPicturesViewController {
                var medias: [(mediaItem: Twitter.MediaItem, tweet: Twitter.Tweet)] = []
                for tweetArray in tweets {
                    for tweet in tweetArray {
                        medias.append(contentsOf: tweet.media.flatMap({ (mediaItem) in
                            return (mediaItem, tweet)
                        }))
                    }
                }
                let tweetsImagesModel = TweetsImagesModel(withMediaItems: medias)
                tweetPicturesVC.viewModel = tweetsImagesModel
                dependencyInjector?.inject(to: tweetPicturesVC)
            }
        default:
            break
        }
    }
    
    // MARK: - Go to the Root View Controller
    @IBAction func backwardAction(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}
