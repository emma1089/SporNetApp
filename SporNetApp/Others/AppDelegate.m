//
//  AppDelegate.m
//  SporNetApp
//
//  Created by Peng on 6/27/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SNUser.h"
#import <AVIMUserOptions.h>
#define AVOSCloudAppID  @"qLvqUSrb3dziuUehRKvpr6Kc-gzGzoHsz"
#define AVOSCloudAppKey @"aYaqxmFig7hp77IYIl1wJ6RU"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //change the style for page indicator
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];    
    
    
    [SNUser registerSubclass];
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];

    //获取当前版本号
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //获取之前的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"LastVersion"];
    if (![lastVersion isEqualToString:version]) {
        NSLog(@"进入广告界面");
        [[NSUserDefaults standardUserDefaults]setValue:version forKey:@"LastVersion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        BOOL haveBasicInfo = [[[NSUserDefaults standardUserDefaults]valueForKey:@"BasicInfo"]boolValue];
        if (!haveBasicInfo) {
            NSLog(@"进入Login填写BasicInfo");
            
        } else {
            NSLog(@"进入message controller");
        }

        
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
