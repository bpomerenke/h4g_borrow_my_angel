//
//  UserSession.swift
//  BorrowMyAngel
//
//  Created by dev1 on 11/3/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

class UserSession {
    static var sharedInstance = UserSession()
    private init(){
        userSessionHandle = ""
    }
    var userSessionHandle: String

    func setHandle(handle: String) {
        userSessionHandle = handle
    }

    func getHandle() -> String {
        return userSessionHandle
    }
}
