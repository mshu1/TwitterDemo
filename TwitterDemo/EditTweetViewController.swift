//
//  EditTweetViewController.swift
//  TwitterDemo
//
//  Created by Michelle Shu on 3/5/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit

class EditTweetViewController: UIViewController {
    weak var delegate: refreshDelegate?
    var replyID: NSString?
    var replyToUser: NSString?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var textInputField: UITextView!
    
    var isReply = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textInputField.becomeFirstResponder()
        self.nameLabel.text = User.currentUser!.name! as String
        // Do any additional setup after loading the view.
        self.screenNameLabel.text = "@" +  (User.currentUser!.screenname!as String)
        self.profileImageView.setImageWith(User.currentUser!.profileUrl! as URL)
        self.editTextforReply(self.isReply)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func editTextforReply(_ isReply: Int) {
        if (isReply == 1) {
            self.textInputField.text = "@" + (self.replyToUser as! String) + "\r\n"
        }
    }
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        let input = self.textInputField.text
        print("want to reply:")
        //print(self.replyID!)
        if (self.isReply == 0){
            TwitterClient.sharedInstance?.tweetNewPost(success: { (newtweet: Tweet) in
                print(input ?? "no message")
                self.delegate?.didChangeHome()
            }, failure:{ (error: Error) in
                print(error.localizedDescription)
            }, tweetMessage: input!)
        } else {
            TwitterClient.sharedInstance?.replyPost(success: { (newtweet: Tweet) in
                print("did reply")
            self.delegate?.didChangeHome()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            }, tweetMessage: input!, replyID: self.replyID as! String)
            
        }
        self.dismiss(animated: false, completion: nil)
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
