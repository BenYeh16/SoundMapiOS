//
//  SharedData.swift
//  SoundMap
//
//  Created by mhci on 2017/6/13.
//  Copyright © 2017年 cnl4. All rights reserved.
//

import Foundation

class SharedData {
    
    var hostname : String = "http://140.112.90.203:4000/";
    
    init() {
        
    }
    
    func getHostName() -> String {
        return hostname;
    }
    
    func getIsLoginSuccess(id: String, password: String) -> String {
        var url = hostname;
        url += "isLoginSuccess";
        url += "/\(id)/\(password)"
        return url;
    }
}
