//
//  SharedData.swift
//  SoundMap
//
//  Created by mhci on 2017/6/13.
//  Copyright © 2017年 cnl4. All rights reserved.
//

import Foundation

final class SharedData {
    
    var hostname : String = "http://140.112.90.203:4000/";
    static var user_id : String = "user";
    
    init() {
        
    }
    
    func setUserId(id: String) {
        SharedData.user_id = id;
    }
    
    func getUserId() -> String {
        return SharedData.user_id;
    }
    
    func getHostName() -> String {
        return hostname;
    }
    
    func getIsLoginSuccess(id: String, password: String) -> String {
        var url = hostname + "isLoginSuccess";
        url += "/\(id)/\(password)"
        return url;
    }
    
    func getSetUserAccount(id: String, password: String) -> String {
        var url = hostname + "setUserAccount";
        url += "/\(id)/\(password)"
        return url;
    }
    
    func getNearByPin(latitude: String, longitude: String) -> String {
        var url = hostname + "getNearByPin";
        url += "/\(latitude)/\(longitude)"
        return url
    }
    
    func getUserPhoto(id: String) -> String {
        var url = hostname + "getUserPhoto";
        url += "/\(id)"
        return url
    }
    
    func getUserAudio(id: String) -> String {
        var url = hostname + "getUserVoice";
        url += "/\(id)"
        return url
    }
    
    func setUserPhoto(id: String) -> String {
        var url = hostname + "setUserPhoto";
        url += "/\(id)"
        return url
    }
    
    func setUserAudio(id: String) -> String {
        var url = hostname + "setUserVoice";
        url += "/\(id)"
        return url
    }
    
}
