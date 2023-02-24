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
import SendbirdChatSDK

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



func loadImageFromModule(_ args: Any?) -> UIImage? {
    guard let imageName = args as? String else {
        return nil
    }
    
    print("[INFO] loadImageFromModule \(imageName)")
    
    // Load the image from the module assets
    let imagePath = Bundle.main.path(forResource: imageName, ofType: "png")
    let image = UIImage(contentsOfFile: imagePath!)
    return image
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class CustomAdminMessageCell: SBUAdminMessageCell {
 
     var avatarImageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
         //imageView.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
         imageView.contentMode = .scaleAspectFill
         imageView.layer.cornerRadius = 14
         imageView.clipsToBounds = true
       return imageView
     }()
    
     let nicknameLabel: UILabel = {
         let label = UILabel()
         label.textColor = .gray
         label.font = .systemFont(ofSize: 12)
         label.text = "Admin User"
         return label
     }()


     
     override func setupViews() {
         super.setupViews()
         
         self.contentView.addSubview(nicknameLabel)
         self.contentView.addSubview(avatarImageView)
         self.messageContentView.addSubview(self.messageLabel)
         
         // NICKNAME LABEL
         nicknameLabel.textColor = theme.userNameTextColor
         nicknameLabel.font = theme.userNameFont
         

         // IMAGE
         
         avatarImageView.load(url: URL(string: "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png")!)
         
         // messageContentView
         self.messageContentView.backgroundColor = UIColor(
            red: CGFloat(0x02) / 255.0,
            green: CGFloat(0xB3) / 255.0,
            blue: CGFloat(0xE4) / 255.0,
            alpha: CGFloat(1)
        )
         self.messageContentView.layer.cornerRadius = 16

         avatarImageView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             avatarImageView.heightAnchor.constraint(equalToConstant: 32), //ok
             avatarImageView.widthAnchor.constraint(equalToConstant: 32),  // ok
             avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 35),   // ok
             avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),   //ok
         ])
         
         nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             nicknameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15), //ok
             nicknameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 60), //ok
         ])
         
         // Remove all the existing constraints for the view
         self.messageContentView.translatesAutoresizingMaskIntoConstraints = true
         self.messageContentView.removeConstraints(self.messageContentView.constraints)
         self.messageLabel.translatesAutoresizingMaskIntoConstraints = true
         self.messageLabel.removeConstraints(self.messageLabel.constraints)
         
         self.messageContentView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             // label container
             self.messageContentView.heightAnchor.constraint(equalTo: self.messageLabel.heightAnchor, constant: 10),
             self.messageContentView.widthAnchor.constraint(equalTo: self.messageLabel.widthAnchor, constant: 5),
             
             self.messageContentView.bottomAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 5),
             self.messageContentView.topAnchor.constraint(equalTo: nicknameLabel.topAnchor, constant: 15), //ok
             self.messageContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 50), //ok
             self.messageContentView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: 5),
        ])
         
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.numberOfLines = 0
        //self.messageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
             //self.messageLabel.topAnchor.constraint(equalTo: self.messageContentView.topAnchor, constant: 10), // 1-era 10 ----
             self.messageLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor, constant: 20),
             //self.messageLabel.bottomAnchor.constraint(equalTo: self.messageContentView.bottomAnchor, constant: -10), // ok
             self.messageLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 60), // ok
             self.messageLabel.trailingAnchor.constraint(equalTo: self.messageContentView.trailingAnchor, constant: -5), // era -20
             self.messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 311),
             self.messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
             //self.messageLabel.centerYAnchor.constraint(equalTo: self.messageContentView.centerYAnchor)
         ])
 
         
     }

     override func setupLayouts() {
         super.setupLayouts()
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         let message = self.messageLabel.text ?? ""
         let attributes: [NSAttributedString.Key : Any] = [
             .font: theme.userMessageFont, // .adminMessageFont
             .foregroundColor : UIColor(
                red: CGFloat(0xFF) / 255.0,
                green: CGFloat(0xFF) / 255.0,
                blue: CGFloat(0xFF) / 255.0,
                alpha: CGFloat(1)
            )//theme.userMessageLeftTextColor, //adminMessageTextColor
             //.backgroundColor: theme.leftBackgroundColor
         ]
         
         let attributedString = NSMutableAttributedString(string: message, attributes: attributes)
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.alignment = .left
         paragraphStyle.lineSpacing = 4
         attributedString.addAttribute(
             .paragraphStyle,
             value: paragraphStyle,
             range: NSMakeRange(0, attributedString.length)
         )
         
         self.messageLabel.attributedText = attributedString
     }

     override func configure(with configuration: SBUBaseMessageCellParams) {
         guard let configuration = configuration as? SBUAdminMessageCellParams else { return }
         guard let message = configuration.adminMessage else { return }
         
         // Configure Content base message cell
         super.configure(with: configuration)
         
         self.messageLabel.text = message.message

         self.layoutIfNeeded()
    }

 }



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



    var sdkInitialized = false
    var userConnected = false
    var userId = ""
    var userName = ""
    var naviVC = UINavigationController()
    let topPresentedController = TiApp.controller().topPresentedController()
    
    @objc(onClickBack)
    func onClickBack() {
        topPresentedController!.dismiss(animated: true) {
            self.fireEvent("app:sendbird_chat_dismissed", with: ["key": "value"])
        }
        //naviVC.popViewController(animated: true)
    }
    
    @objc(initSendbird:)
    func initSendbird(arguments: Array<Any>?) {
        print("[DEBUG] initSendbird method")
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
        
        let appId = options["appId"] as? String ?? ""
        SendbirdUI.setLogLevel(.all)
        // seems to be sync
        SendbirdUI.initialize(applicationId: appId) { // This is the origin.
            // Initialization of SendbirdUIKit has started.
            // Show a loading indicator.
            debugPrint("[INFO] Initialization of SendbirdUIKit has started. Show a loading indicator.")
        } migrationHandler: {
            // DB migration has started.
            debugPrint("[INFO] DB migration has started.")
        } completionHandler: { error in
            // If DB migration is successful, proceed to the next step.
            // If DB migration fails, an error exists.
            // Hide the loading indicator.
            if error != nil {
                // handle error
                callback.call([["success": false, "error": "\(String(describing: error))"]], thisObject: self)
            }
        }
        
        SBUGlobals.isChannelListMessageReceiptStateEnabled = true
        SBUGlobals.isChannelListTypingIndicatorEnabled = true
        //SBUFontSet.body1 = .systemFont(ofSize: 20, weight: .regular)
        
        sdkInitialized = true
        callback.call([["success": true, "message": "Sdk initialized"]], thisObject: self)
    }

    
    @objc(registerDevicePushToken:)
    func registerDevicePushToken(arguments: Array<Any>?) {
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
        let deviceToken = options["deviceToken"] as? String ?? ""
        if(deviceToken.count > 0) {
            let deviceTokenData = hexDecodedData(textToEncode:deviceToken)
            SendbirdChat.registerDevicePushToken(deviceTokenData, unique: false) { status, error in
                if error == nil {
                    // A device token is successfully registered.
                    callback.call([["success": true, "message": "User is connected to Sendbird server and device token registered \(String(describing: deviceToken)) and data \(String(describing: deviceTokenData))", "tokenStatus": "registered"]], thisObject: self)
                }
                else {
                    if status == PushTokenRegistrationStatus.pending {
                        // A token registration is pending.
                        // If this status is returned,
                        // invoke the registerDevicePushToken:unique:completionHandler:
                        // with [SendbirdChat getPendingPushToken] after connection.
                        callback.call([["success": true, "message": "User is connected to Sendbird server and device token is PENDING \(String(describing: deviceToken))", "tokenStatus": "pending"]], thisObject: self)
                    }
                    else {
                        // Handle registration failure.
                        callback.call([["success": true, "message": "User is connected to Sendbird server and device token registration has error \(String(describing: error))", "tokenStatus": "error"]], thisObject: self)
                    }
                }
            }
        } else {
            callback.call([["success": false, "error": "No device token received", "tokenStatus": "error"]], thisObject: self)
        }
    }
    
    @objc(disconnectUser:)
    func disconnectUser(arguments: Array<Any>?) {
        self.fireEvent("app:sendbird_chat_log", with: ["message": "disconnectUser()"])
        SendbirdChat.disconnect()
        userConnected = false
        SBUGlobals.currentUser = nil

    }
    
    @objc(unregisterPushToken:)
    func unregisterPushToken(arguments: Array<Any>?) {
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
        let deviceToken = options["deviceToken"] as? String ?? ""
        if(deviceToken.count > 0) {
            let deviceTokenData = hexDecodedData(textToEncode:deviceToken)
            SendbirdChat.unregisterPushToken(deviceTokenData) { response, error in
                guard error == nil else {
                    // Handle error.
                    callback.call([["success": false, "error": "\(String(describing: error))"]], thisObject: self)
                    return
                }
                callback.call([["success": true, "message": "User device token was unregistered"]], thisObject: self)
            }
        } else {
            callback.call([["success": false, "error": "No device token received"]], thisObject: self)
        }
    }
    
    @objc(unregisterAllPushToken:)
    func unregisterAllPushToken(arguments: Array<Any>?) {
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
        SendbirdChat.unregisterAllPushToken { (response, error) in
            guard error == nil else {
                // Handle error.
                callback.call([["success": false, "error": "\(String(describing: error))"]], thisObject: self)
                return
                
            }
            callback.call([["success": true, "message": "All user devices tokens were unregistered"]], thisObject: self)
        }
        
    }
    
    @objc(connectUser:)
    func connectUser(arguments: Array<Any>?) {
        print("[DEBUG] connectUser method")
        self.fireEvent("app:sendbird_chat_log", with: ["message": "connectUser()"])
        
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
        userId = options["userId"] as? String ?? ""
        userName = options["userName"] as? String ?? ""
        let authToken = options["authToken"] as? String ?? ""
        let deviceToken = options["deviceToken"] as? String ?? ""
        SendbirdChat.connect(userId: userId, authToken: authToken) { [self]user, error in
            guard error == nil else {
                // Handle error.
                callback.call([["success": false, "error": authToken + " \(String(describing: error))"]], thisObject: self)
                return
            }
            userConnected = true
            SBUGlobals.currentUser = SBUUser(userId: userId, nickname: userName)

            self.fireEvent("app:sendbird_chat_log", with: ["message": "connectUser - check deviceToken \(String(describing: deviceToken))"])
            
            if(deviceToken.count > 0) {
                self.fireEvent("app:sendbird_chat_log", with: ["message": "connectUser - will decode token"])
               
                let deviceTokenData = hexDecodedData(textToEncode:deviceToken)
                
                self.fireEvent("app:sendbird_chat_log", with: ["message": "connectUser - will registerDevicePushToken"])
                SendbirdChat.registerDevicePushToken(deviceTokenData, unique: false) { status, error in
                    if error == nil {
                        // A device token is successfully registered.
                        callback.call([["success": true, "message": "User is connected to Sendbird server and device token registered \(String(describing: deviceToken)) and data \(String(describing: deviceTokenData))"]], thisObject: self)
                    }
                    else {
                        if status == PushTokenRegistrationStatus.pending {
                            // A token registration is pending.
                            // If this status is returned,
                            // invoke the registerDevicePushToken:unique:completionHandler:
                            // with [SendbirdChat getPendingPushToken] after connection.
                            callback.call([["success": true, "message": "User is connected to Sendbird server and device token is PENDING \(String(describing: deviceToken))"]], thisObject: self)
                        }
                        else {
                            // Handle registration failure.
                            callback.call([["success": true, "message": "User is connected to Sendbird server and device token registration has error \(String(describing: error))"]], thisObject: self)
                        }
                    }
                }
            } else {
                
                callback.call([["success": true, "message": "User is connected to Sendbird server"]], thisObject: self)
            }
        }
    }
    
    @objc(launchChat:)
    func launchChat(arguments: Array<Any>?) {
        self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat()"])
        print("[DEBUG] launchChat method")
        guard let arguments = arguments, let options = arguments[0] as? [String: Any] else { return }
        guard let callback: KrollCallback = options["onComplete"] as? KrollCallback else { return }
     
        if (!sdkInitialized) {
            callback.call([["success": false, "error": "Sdk is not initialized"]], thisObject: self)
            return
        }
        if (!userConnected) {
            callback.call([["success": false, "error": "User not connected to Sendbird server"]], thisObject: self)
            return
        }
            
        let receiverUserId = options["receiverUserId"] as? String ?? ""
        let receiverUserName = options["receiverUserName"] as? String ?? ""
        let groupName = options["groupName"] as? String ?? ""
        let groupAvatarFile = options["groupAvatarFile"] as? String ?? ""
        let groupAvatarUrl = options["groupAvatarUrl"] as? String ?? ""
        let groupChannelUrl = options["groupChannelUrl"] as? String ?? ""
        let groupCustomType = options["groupCustomType"] as? String ?? ""
        
        self.fireEvent("app:sendbird_chat_log", with: ["receiverId": receiverUserId, "groupAvatarFile": groupAvatarFile])
        
        if naviVC.viewIfLoaded?.window != nil {
            // viewController is visible
            print("[WARN] naviVC is visible")
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - window is open"])
            if (groupChannelUrl.count > 0) {
                self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - channel url exists"])
                SendbirdUI.moveToChannel(channelURL: groupChannelUrl, basedOnChannelList: true)
                callback.call([["success": true, "message": "Chat opened on already visible controller"]], thisObject: self)
                return
            }
        } else {
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - window not opened"])
            print("[WARN] naviVC is NOT visible")
            //callback.call([["success": false, "error": "naviVC is NOT visible"]], thisObject: self)
        }

        if (groupChannelUrl.count > 0) {
            // we already have a channel
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - have a channel URL"])
            GroupChannel.getChannel(url: groupChannelUrl) { channel, error in
                guard error == nil else {
                    // Handle error.
                    callback.call([["success": false, "error with URL": "\(String(describing: error))"]], thisObject: self)
                    
                    return
                }
                self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - will openChat"])
                
                openChat(channel: channel!)
                
            }
        } else {
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - no channel URL"])
            let userIds = [userId, receiverUserId]
            let params = GroupChannelCreateParams()
            params.isDistinct = true
//            if (groupAvatarFile.count > 0) {
//                params.coverImage = loadImage(filepath: groupAvatarFile)
//            } else {
//                params.coverURL = groupAvatarUrl
//            }
            params.name = groupName
            params.userIds = userIds
            //params.channelURL = groupChannelUrl
            params.customType = groupCustomType
            
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - will create channel"])
            GroupChannel.createChannel(params: params) { channel, error in
                if error != nil {
                    // can't create channel
                    callback.call([["success": false, "error": "\(String(describing: error))"]], thisObject: self)
                    return
                }
                
                self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - will open chat"])
                openChat(channel: channel!)
                
            }
        }
        
        func openChat(channel: GroupChannel) {
            
            // use the created channel for one-to-one chat
            let channelVC = SBUGroupChannelViewController(
                channel: channel,
                messageListParams: nil
            )
            
            let rightButton = UIButton(type: .custom)
            rightButton.frame = .init(x: 0, y: 0, width: 0, height: 0)
            rightButton.setTitle("", for: .normal)
            let rightBarButton = UIBarButtonItem(customView: rightButton)
            channelVC.headerComponent?.rightBarButton = rightBarButton
            
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - will change button"])
            let backButton: UIButton
            if #available(iOS 13.0, *) {
                backButton = UIButton(type: .close)
            } else {
                // Fallback on earlier versions
                backButton = UIButton(type: .custom)
                backButton.frame = .init(x: 0, y: 0, width: 50, height: 60)
                backButton.setTitle("<", for: .normal)
            }

            backButton.tintColor = UIColor(
                red: CGFloat(0x02) / 255.0,
                green: CGFloat(0xB3) / 255.0,
                blue: CGFloat(0xE4) / 255.0,
                alpha: CGFloat(1)
            )
            backButton.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
            let backBarButton = UIBarButtonItem(customView: backButton)
            channelVC.headerComponent?.leftBarButton = backBarButton
            
            //channelVC.listComponent!.register(userMessageCell: CustomUserMessageCell())
            
            channelVC.listComponent!.register(adminMessageCell: CustomAdminMessageCell())
            
            self.fireEvent("app:sendbird_chat_log", with: ["message": "launchChat - button changed"])
            
            naviVC = UINavigationController(rootViewController: channelVC)
            naviVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            
            topPresentedController!.present(naviVC, animated: true) {
                // This code gets executed after the modal window is dismissed
                self.fireEvent("app:sendbird_chat_opened", with: ["key": "value"])
            }
            
            callback.call([["success": true, "message": "Chat opened"]], thisObject: self)
        }
        

        return
    }
    
    func hexDecodedData(textToEncode: String) -> Data {
        // Get the UTF8 characters of this string
        let chars = Array(textToEncode.utf8)

        // Keep the bytes in an UInt8 array and later convert it to Data
        var bytes = [UInt8]()
        bytes.reserveCapacity(textToEncode.count / 2)

        // It is a lot faster to use a lookup map instead of strtoul
        let map: [UInt8] = [
          0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, // 01234567
          0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 89:;<=>?
          0x00, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x00, // @ABCDEFG
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  // HIJKLMNO
        ]

        // Grab two characters at a time, map them and turn it into a byte
        for i in stride(from: 0, to: textToEncode.count, by: 2) {
          let index1 = Int(chars[i] & 0x1F ^ 0x10)
          let index2 = Int(chars[i + 1] & 0x1F ^ 0x10)
          bytes.append(map[index1] << 4 | map[index2])
        }

        return Data(bytes)
    }
    func loadImage(filepath: String) -> Data {
        var data: Data? = nil
        let fileLocation = Bundle.main.path(forResource: filepath, ofType: "png")
        self.fireEvent("app:sendbird_chat_log", with: ["message": fileLocation])
        let url = URL(fileURLWithPath: fileLocation!)
        data = try? Data(contentsOf: url)
        return data!
        //let uiImage: UIImage = UIImage(data: data!)!
        //return uiImage
    }
}
