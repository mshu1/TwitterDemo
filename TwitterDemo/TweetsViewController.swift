//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
