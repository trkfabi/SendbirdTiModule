//
//  ComInzoriSendbirdModule.swift
//  Sendbird
//
//  Created by Fabian Martinez
//  Copyright (c) 2023 Your Company. All rights reserved.
//

import UIKit
import TitaniumKit
import SendbirdUIKit


/**
 
 Titanium Swift Module Requirements
 ---
 
 1. Use the @objc annotation to expose your class to Objective-C (used by the Titanium core)
 2. Use the @objc annotation to expose your method to Objective-C as well.
 3. Method arguments always have the "[Any]" type, specifying a various number of arguments.
 Unwrap them like you would do in Swift, e.g. "guard let arguments = arguments, let message = arguments.first"
 4. You can use any public Titanium API like before, e.g. TiUtils. Remember the type safety of Swift, like Int vs Int32
 and NSString vs. String.
 
 */

@objc(ComInzoriSendbirdModule)
class ComInzoriSendbirdModule: TiModule {

  func moduleGUID() -> String {
    return "a29379f1-91d1-462e-a99a-ab8256581065"
  }
  
  override func moduleId() -> String! {
    return "com.inzori.sendbird"
  }

  override func startup() {
    super.startup()
    print("[DEBUG] \(self) loaded")

  }


    @objc(initSendbird:)
    func initSendbird(arguments: Array<Any>?) {
        print("[DEBUG] initSendbird method")
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
     
        var appId = ""
        if options["appId"] != nil {
            appId = options["appId"] as! String
        }
        var userId = ""
        if options["userId"] != nil {
            userId = options["userId"] as! String
        }
        var userName = ""
        if options["userName"] != nil {
            userName = options["userName"] as! String
        }
        
        SendbirdUI.initialize(applicationId: appId) { // This is the origin.
            // Initialization of SendbirdUIKit has started.
            // Show a loading indicator.
            print("[DEBUG] Initialization of SendbirdUIKit has started. Show a loading indicator.")
        } migrationHandler: {
            // DB migration has started.
            print("[DEBUG] DB migration has started.")
        } completionHandler: { error in
            // If DB migration is successful, proceed to the next step.
            // If DB migration fails, an error exists.
            // Hide the loading indicator.
            debugPrint("done")
            let description = "\(error)"
            callback.call([["error": description]], thisObject: self)
        }
        callback.call([["success": true]], thisObject: self)
        
        // Case 2: Specify all fields
        SBUGlobals.currentUser = SBUUser(userId: userId, nickname: userName)
        
        callback.call([["success": true, "userId": userId, "userName": userName]], thisObject: self)

        let channelListVC = SBUGroupChannelListViewController()
        let naviVC = UINavigationController(rootViewController: channelListVC)

        guard let controller = TiApp.controller(), let topPresentedController = controller.topPresentedController() else {
          print("[WARN] No window opened. Ignoring gallery call …")
            callback.call([["success": false, "message": "No window opened. Ignoring gallery call …"]], thisObject: self)
          return
        }

        callback.call([["success": true, "message": "will present VC"]], thisObject: self)
        topPresentedController.present(naviVC, animated: true, completion: nil)
        
        
        callback.call([["success": true, "message": "finish"]], thisObject: self)
        return
    }


}
