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
        channelUrl = ""
    }
    var userSessionHandle: String
    var sBDUser: SBDUser?
    var channelUrl: String

    func setHandle(handle: String? = nil) {
        guard handle == nil else {
            userSessionHandle = handle!
            return
        }
        userSessionHandle = "PIN " + NSUUID().uuidString
    }

    //this whole thing belongs in a server somewhere.  sorry - tp
    //todo: rename connect PIN to angel
    //todo: closure tells when channel is selected or time runs out...
    func setSBDUser(user: SBDUser?) {
        sBDUser = user

        self.enterNotConnectedChannel() { (notConnected) in
            guard notConnected != nil else {
                return
            }

            //if more than 2 are in the notConnected channel wait .1 seconds and loop
            print("participant count:")
            print(notConnected?.participantCount)

            self.getAllUsers(notConnected: notConnected) { (users) in
                guard notConnected != nil else {
                    return
                }

                if(self.isAngel()) {

                    //find 1 user who 1. is PIN 2. is has connection status
                    let pinUser = users?.first(){ (user) -> Bool in
                        return user.userId.starts(with: "PIN")
                    }

                    guard pinUser != nil else {
                        return
                    }

                    //send that user a message to join this room
//                    notConnected?.sendUserMessage("join me in room:" + self.getHandle()) {
//                    (message, error) in
//                        guard error == nil else {
//                            //todo: report failure to end users
//                            return
//                        }

//                        self.enterMyChannel(notConnected: notConnected!) {() in
//                            print("angel joined his/her own room")
//                        }

                        //that user will have to call enterAngelChannel
                        //tell me that a user joined this channel
//                    }
                    return
                } else {
                    //find 1 user who 1 is NOT PIN //2. who is in the notConnected channel
                    let noPinUser = users?.first(){ (user) -> Bool in
                        return !user.userId.starts(with: "PIN")
                    }

                    print("noPinUser")
                    users?.forEach({ (u) in
                        print(u.userId)
                    })

                    guard noPinUser != nil else {
                        return
                    }

                    //join SBDGroupChannel by my username
//                    self.enterChannel(channelName: noPinUser!.userId) {(_) in
//                        print("joined angel room")
//                        print(noPinUser?.userId)

//                        self.leaveNotConnectedChannel(channel: notConnected!)
//                    }
                }
                //todo: check for successful and potentially navigate to the failed connections page
            }
        }
    }

    func enterNotConnectedChannel(successHandler: ((SBDOpenChannel?) -> Void)?) {
        SBDOpenChannel.createOpenChannelListQuery()?.loadNextPage() { (channels, error) in
            guard error == nil else {
                print("error getting open channel list: \(String(describing: error?.description))")
                return
            }

            let notConnectedChannel = channels?.first(where: { (channel) -> Bool in
                print(channel.name)
                return channel.name == "notConnected"
            })

            guard notConnectedChannel != nil else {
                print("can not find not connected channel")
                return
            }

            self.channelUrl = notConnectedChannel!.channelUrl

            successHandler?(notConnectedChannel)
        }
    }

    func enterChannel(channelName: String, successHandler: ((SBDOpenChannel?) -> Void)?) {
        return SBDOpenChannel.getWithUrl(channelName){ (channel, error) in
            guard error == nil else {
                print("error getting channel with NotConnected url: \(String(describing: error?.description))")
                return
            }

            self.channelUrl = channel!.channelUrl

            successHandler?(channel)
        }
    }

    func enterMyChannel(notConnected: SBDOpenChannel?, successHandler: (() -> Void)?) {
        let meetingRoomName = self.getHandle()

        print(meetingRoomName)

        SBDOpenChannel.createOpenChannelListQuery()?.loadNextPage() { (channels, error) in
            guard error == nil else {
                print("error getting open channel list: \(String(describing: error?.description))")
                return
            }

            let channelByName = channels?.first(where: { (channel) -> Bool in
                print(channel.name)
                return channel.name == meetingRoomName
            })

            guard channelByName == nil else {
                SBDOpenChannel.createChannel(withName: meetingRoomName, coverUrl: nil, data: nil, operatorUserIds: nil) { (meetingRoomChannel, error) in
                    guard error == nil else {
                        print("error getting MyChannel with url: \(String(describing: error?.description))")
                        return
                    }

                    self.channelUrl = meetingRoomChannel!.channelUrl

                    successHandler?()
                }

                return
            }

            self.channelUrl = channelByName!.channelUrl

            successHandler?()
        }
    }

    func getAllUsers(notConnected: SBDOpenChannel?, successHandler: (([SBDUser]?) -> Void)?) {
        notConnected?.createParticipantListQuery()?.loadNextPage(){(sbdUsers, error) in
            guard error == nil else {
                print("error getting users for notConnected channel")
                return
            }
            successHandler?(sbdUsers)
        }
    }

//    func pairJoinedChannel(notConnected: SBDOpenChannel, user: SBDUser, successHandler: (() -> Void)?) {
//        self.leaveNotConnectedChannel(channel: notConnected)
//
//        enterNotConnectedChannel() { (channel) in
//            guard channel != nil else {
//                return
//            }
//            successHandler?()
//        }
//    }

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
        print("channel URL")
        print(channelUrl)

        return channelUrl
    }

    func getHandle() -> String {
        return userSessionHandle
    }

    func isAngel() -> Bool {
        return userSessionHandle.count > 0 && !userSessionHandle.starts(with: "PIN")
    }
}
