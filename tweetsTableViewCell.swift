//
//  tweetsTableViewCell.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class tweetsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textInfoLabel: UILabel!
    var tweet: Tweet! {
        didSet{
            self.textInfoLabel.text = tweet.text as String?
            
            //screen name
            var screenName = "@"
            screenName.append((tweet.screenName as String?)!)
            
            self.userIDLabel.text = screenName
            self.userNameLabel.text = tweet.userName as String?
            
            // time conversion
            let timeAgo = Int(Date().timeIntervalSince(tweet.timestamp! as Date))
            let ago = convertTimeAgo(seconds: timeAgo)
            
            dateLabel.text = ago
            
            //image profile 
            let profileUrl = URL(string: tweet.profileUrl as String!)
            profileImageView.setImageWith(profileUrl!)

        }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
