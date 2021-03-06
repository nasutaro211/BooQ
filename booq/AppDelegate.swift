//
//  AppDelegate.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/15.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Flurry.startSession("MZ2CXG4R3XJZQCJ92ZQF", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        //マイグレーション
        let config = Realm.Configuration(
            //現在出ているアプリのschemaverは[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]//注目
            // 新しいデータベース構造のバージョンを宣言。
            //バージョンは以前使っていたバージョンよりも大きいものにする(まだマイグレーションをしたことがないときのバージョンは0)
            schemaVersion: 1,
            // 新しいバージョンに書き換えらる時に自動的に呼ばれるブロックを引数に渡す
            migrationBlock: { migration, oldSchemaVersion in
                // まだマイグレーションをしたことがないのでoldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    /*ここにマイグレーションする時のコードを書く*/
                    //Questionsのマイグレーション
                    migration.enumerateObjects(ofType: Question.className()) { oldObject, newObject in
                        //ひとまずnumInBookをマイグレート
                        if (newObject!["numInBook"] as! String) == ""{
                            //0->1のバージョン移行
                            newObject!["numInBook"] = oldObject!["questionID"] as! String
                        }
                    }
                    //Bookのマイグレーション
                    migration.enumerateObjects(ofType: Book.className(), { oldObject, newObject in
                        if (oldObject!["imageData"] != nil){
                            let imageData = oldObject!["imageData"] as! Data
                            let image = UIImage(data: imageData)
                            let originImage = resizeImage(image: image!, w: 50, h: 150)
                            let pngImageData = UIImagePNGRepresentation(originImage)
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = documentsURL.appendingPathComponent((oldObject!["ISBN"] as! String))
                            try! pngImageData!.write(to: fileURL)
                        }
                    })
                }
        })
        
        //         デフォルトで呼ばれるRealmに今回設定したバージョンのものを設定
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

