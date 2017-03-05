//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshDelegate {
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.217, green: 0.658, blue: 1.000, alpha: 0.5)
        tableView.delegate = self
        tableView.dataSource = self
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //for tweet in self.tweets {
               //print(tweet.text!)
            //}
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
        //twitterClient?.currentAccount()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            print("yes tweets?")
            return self.tweets.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! tweetsTableViewCell
        let tweet = tweets[indexPath.row]
        cell.textInfoLabel.text = tweet.text as String?
        
        //screen name
        var screenName = "@"
        screenName.append((tweet.screenName as String?)!)
        
        cell.userIDLabel.text = screenName
        cell.userNameLabel.text = tweet.userName as String?
        cell.favoriteNum.text = String(tweet.favoritesCount)
        cell.retweetNum.text = String(tweet.retweetCount)
        // time conversion
        let timeAgo = Int(Date().timeIntervalSince(tweet.timestamp! as Date))
        let ago = convertTimeAgo(seconds: timeAgo)
        
        cell.dateLabel.text = ago
        cell.tweetID = tweet.tweetID
        //image profile
        let profileUrl = URL(string: tweet.profileUrl as String!)
        cell.profileImageView.setImageWith(profileUrl!)
        return cell
    }
    
    func convertTimeAgo(seconds: Int) -> String {
        var result: String?
        
        if(seconds/60 <= 59) {
            result = "\(seconds/60) m"
        } else if (seconds/3600 <= 23) {
            result = "\(seconds/3600) h"
        } else {
            result = "\(seconds/216000) d"
        }
        return result!
    }

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogOut(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectCellSegue") {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let sentTweet = tweets[indexPath!.row]
        let vc = segue.destination as! DetailTweetViewController
        vc.tweet = sentTweet
        vc.delegate = self
        }
        if (segue.identifier == "postTweetSegue"){
            let vc = segue.destination.childViewControllers[0] as! EditTweetViewController
            vc.delegate = self
            vc.isReply = 0
            // Pass the selected object to the new view controller.
        }
        if (segue.identifier == "replyFromCell") {
            let button = sender as! UIButton
            let cell = button.superview?.superview as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let sentTweet = tweets[indexPath!.row]
           let vc = segue.destination.childViewControllers[0] as! EditTweetViewController
            vc.delegate = self
            vc.isReply = 1
            vc.replyID = sentTweet.tweetID
            vc.replyToUser = sentTweet.screenName
        }
        
        
    }
    
    func didChangeHome() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //for tweet in self.tweets {
            //print(tweet.text!)
            //}
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    


}
