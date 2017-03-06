//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 3/5/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    var user: NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI(){
        //set the profile picture
        let profilePictureUrlString = user?["profile_image_url_https"] as? String
        let profilePictureUrl = URL(string: profilePictureUrlString!)
        profilePicture.setImageWith(profilePictureUrl!)
        
        
        //set the profile banner
        let profileBannerUrlString = user?["profile_banner_url"] as? String
        
        if profileBannerUrlString != nil {
            let profileBannerUrl = URL(string: profileBannerUrlString!)
            profileBanner.setImageWith(profileBannerUrl!)
            
            //blur the profile banner
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = profileBanner.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            profileBanner.addSubview(blurEffectView)
        }
        
        
        //set screen name
        let screenName = user!["screen_name"] as! String
        self.screenName.text = "@\(screenName)"
        
        userName.text = user!["name"] as? String
        
        //set tweets label
        let status_count = user!["statuses_count"]!
        self.tweetsLabel.text = "\(status_count)"
        
        //set following label
        let follower_count = user!["followers_count"]!
        self.followingLabel.text = "\(follower_count)"
        
        //set followers label
        let friend_count = user!["friends_count"]!
        self.followersLabel.text = "\(friend_count)"
        
        
        
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
