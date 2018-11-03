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

    func setHandle(handle: String? = nil) {
        guard handle == nil else {
            userSessionHandle = handle!
            return
        }
        userSessionHandle = ""
    }

    func setSBDUser(user: SBDUser?) {
        sBDUser = user
    }

    func getHandle() -> String {
        if(isAngel()) {
            return userSessionHandle
        } else {
            return "Person_In_Need" + NSUUID().uuidString
        }
    }

    func isAngel() -> Bool {
        return userSessionHandle.count > 0
    }
}
