//
//  TweetTabBarController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit

class TweetTabBarController: UITabBarController {

    //var dependencyInjector: DependencyInjector?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tweetersAction(_ sender: UIBarButtonItem) {
        guard let searchVC = selectedViewController as? SmashTweetTableViewController else { return }
        searchVC.performSegue(withIdentifier: "Tweeters Mentioning Search Term", sender: sender)
    }
    
    @IBAction func tweetsPicturesAction(_ sender: UIBarButtonItem) {
        guard let searchVC = selectedViewController as? SmashTweetTableViewController else { return }
        searchVC.performSegue(withIdentifier: "TweetPicturesSegueID", sender: sender)
    }
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let segueIdentifier = segue.identifier else { return }
//        switch segueIdentifier {
//        case "Tweeters Mentioning Search Term":
//            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
//                tweetersTVC.mention = searchText
//                tweetersTVC.container = container
//            }
//        case "TweetPicturesSegueID":
//            if let tweetPicturesVC = segue.destination as? TweetPicturesViewController {
//                var medias: [(mediaItem: Twitter.MediaItem, tweet: Twitter.Tweet)] = []
//                for tweetArray in tweets {
//                    for tweet in tweetArray {
//                        medias.append(contentsOf: tweet.media.flatMap({ (mediaItem) in
//                            return (mediaItem, tweet)
//                        }))
//                    }
//                }
//                let tweetsImagesModel = TweetsImagesModel(withMediaItems: medias)
//                tweetPicturesVC.viewModel = tweetsImagesModel
//                dependencyInjector?.inject(to: tweetPicturesVC)
//            }
//        default:
//            break
//        }
//    }
}
