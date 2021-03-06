//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 2/26/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "XShln3IIdhMXjWOlY8nZZ1D5u", consumerSecret: "awIMxQfMd1oegXnTCaLwHe3Jt8tWyfNNBzSn7MU5LA84XlvH9o")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error)-> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token :)!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") as! URL
            UIApplication.shared.openURL(url)
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }

    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            self.currentAccount(success: { (user:User) in
                print("reach this??")
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
                self.loginSuccess?()
        }, failure: { (error: Error?) -> Void in
            self.loginFailure?(error!)        
        })
    }
    
    
    func homeTimeLine(success:@escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
        }
    
    
    func currentAccount(success:@escaping (User) -> (), failure:@escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { ( task:
            URLSessionDataTask?, response: Any?) -> Void in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
}
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)
    }
    
    
    func retweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: String) {
        post("1.1/statuses/retweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("retweet")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    
    func favorite(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: String) {
        print("\(Int(tweetID))")
        post("1.1/favorites/create.json", parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("favorite")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func tweetNewPost(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetMessage: String) {
        post("1.1/statuses/update.json", parameters: ["status":tweetMessage], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("tweetPost")
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    
    }
    
    func replyPost(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetMessage: String, replyID: String) {
        post("1.1/statuses/update.json", parameters: ["status":tweetMessage, "in_reply_to_status_id":replyID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("tweetPost")
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    func fetchUserInfor(success: @escaping (User) -> (), failure: @escaping (Error) -> (), userScreenName: String) {
        post("1.1/users/show.json", parameters: ["status":userScreenName], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("fetchedUserInfor")
            let dictionary = response as! NSDictionary
            let user = User(dictionary: dictionary)
            success(user)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }

    }
    
    
    
    
}

