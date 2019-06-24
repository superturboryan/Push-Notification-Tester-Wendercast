//Ryan Forsyth
//June 24 2019
//Push notification tutorial from raywenderlich.com

//Ryan Device token: 398f8efae9aa612b43c8f652b74310eb851c0da1e22cc0adb91fe8ee28ecc62c
//Team id: T6MXF72738
//Key id: 37A2B2X747


import UIKit
import SafariServices
import UserNotifications

enum Identifiers {
  static let viewAction = "VIEW_IDENTIFIER"
  static let newsCategory = "NEWS_CATEGORY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    UITabBar.appearance().barTintColor = UIColor.themeGreenColor
    UITabBar.appearance().tintColor = UIColor.white
    
    registerForPushNotifications()
    
    // Check if launched from notification
    let notificationOption = launchOptions?[.remoteNotification]
    
    // 1
    if let notification = notificationOption as? [String: AnyObject],
      
      let aps = notification["aps"] as? [String: AnyObject] {
      
      // 2
      NewsItem.makeNewsItem(aps)
      
      // 3
      (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
    }
    
    return true
  }
  
  
  func registerForPushNotifications() {
    UNUserNotificationCenter.current() // 1
      .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
        granted, error in
        
        print("Permission granted: \(granted)")
        guard granted else { return }
        self.getNotificationSettings()
    }
  }
  
  
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("Notification settings: \(settings)")
      
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }

    }
  }
  
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }

  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
   
    print("Failed to register: \(error)")
  }
  
  
}



