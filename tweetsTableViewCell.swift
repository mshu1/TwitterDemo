//
//  tweetsTableViewCell.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func profileImageTapped(cell: tweetsTableViewCell, user: NSDictionary)
}

class tweetsTableViewCell: UITableViewCell {
    
    
    weak var profiledelegate: TweetCellDelegate?

    //@IBOutlet weak var profileI: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textInfoLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retreatButton: UIButton!

    @IBOutlet weak var favoriteNum: UILabel!
    
    @IBOutlet weak var retweetNum: UILabel!
    var user: User!
    var tweetID:NSString?
    var tweet: Tweet!
    weak var delegate: refreshDelegate?



    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        profileImageView.isUserInteractionEnabled = true //make sure this is enabled
        //tap for userImageView
        let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
        profileImageView.addGestureRecognizer(userProfileTap)

        }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer){
        if let profiledelegate = profiledelegate{
            profiledelegate.profileImageTapped(cell: self, user: (self.tweet?.user)!)
        }
    }
    
    
    
    @IBAction func onRetweet(_ sender: Any) {
        print("tweet ID: \(tweetID)")
        
        self.retreatButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
        self.retweetNum.textColor = UIColor.green
        
        TwitterClient.sharedInstance?.retweet(success: { (tweet: Tweet) in
            print(tweet.retweetCount)
            self.retweetNum.text = "\(tweet.retweetCount)"
            self.tweet = tweet
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        }, tweetID: tweetID as! String)
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        print("tweet ID: \(tweetID)")
        
        self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
        self.favoriteNum.textColor = UIColor.red
        
        TwitterClient.sharedInstance?.favorite(success: { (tweet: Tweet) in
            print(tweet.favoritesCount)
            self.favoriteNum.text = "\(tweet.favoritesCount)"
            self.tweet = tweet
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        }, tweetID: tweetID as! String)
    }
        
    
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
