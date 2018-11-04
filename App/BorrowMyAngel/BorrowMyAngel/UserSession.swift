//
//  UserSession.swift
//  BorrowMyAngel
//
//  Created by dev1 on 11/3/18.
//  Copyright © 2018 hack4good. All rights reserved.
//
import SendBirdSDK

class UserSession {
    static var sharedInstance = UserSession()
    private init(){
        userSessionHandle = ""
    }
    var userSessionHandle: String
    var sBDUser: SBDUser?
    var channelUrl: String?

    func setHandle(handle: String? = nil) {
        guard handle == nil else {
            userSessionHandle = handle!
            return
        }
        userSessionHandle = ""
    }

    //rename go to room
    func setSBDUser(user: SBDUser?) {
        sBDUser = user

        enterNotConnectedChannel() { (channel) in
            guard channel != nil else {
                return
            }

            //if more than 2 are in the notConnected channel wait .1 seconds and loop
//        if(!isAngel()) {
//            //get all users and find 1 user who 1 is PIN //2. who is in the notConnected channel
//        } else {
//
//            //create SBDGroupChannel by my username
//            //get all users and find 1 user who 1. is NOT PIN //2. who is in the notConnected channel //3. is has connection status and
//        }
        //if successful
            self.leaveNotConnectedChannel(channel: channel!)
        }
    }

    func enterNotConnectedChannel(successHandler: ((SBDOpenChannel?) -> Void)?) {
        return SBDOpenChannel.getWithUrl("notConnected"){ (channel, error) in
            guard error == nil else {
                print("error getting channel with url: \(String(describing: error?.description))")
                return
            }

            successHandler?(channel)
        }
    }

    func leaveNotConnectedChannel(channel: SBDOpenChannel) {
        return channel.exitChannel(){ (error) in
            guard error == nil else {
                print("error exiting channel")
                print(error?.description)
                return
            }
        }
    }

    func getRoomUrl() -> String{
        return "test"
    }

    func getHandle() -> String {
        if(isAngel()) {
            return userSessionHandle
        } else {
            return "PIN " + NSUUID().uuidString
        }
    }

    func isAngel() -> Bool {
        return userSessionHandle.count > 0
    }
}
