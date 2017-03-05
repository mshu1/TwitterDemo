//
//  User.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var tweetsNum: Int = 0
    var followersNum: Int = 0
    var friendsNum: Int = 0
    var backgroundUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        //deserialization code
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        
        
        followersNum = (dictionary["followers_count"] as? Int) ?? 0
        friendsNum = (dictionary["friends_count"] as? Int) ?? 0
        tweetsNum = (dictionary["statuses_count"] as? Int) ?? 0
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = NSURL(string: backgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                //let dictionary = try! JSONSerialization.data(withJSONObject: userData, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)

                }
            }
            return _currentUser

        }
    
        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            print("reach set user")
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
           // defaults.set(user, forKey: "currentUser")
            //defaults.synchronize()
            
            
        }
    }

}
