//
//  flurry_user_sessions.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/31.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import Foundation
import Flurry_iOS_SDK

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Flurry.startSession("R22RCFQHQZ6KP38PBQ47");
    // Your code...
    return true;
}
