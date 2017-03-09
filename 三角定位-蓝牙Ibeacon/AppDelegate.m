//
//  AppDelegate.m
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "AppDelegate.h"
#import "BRTBeaconSDK.h"
static NSString *const AppKey =@"5dbb653cccef4fd8813958e0bdf1f924";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

     [self regisonAppkey];
    
    return YES;
}
//注册appkey
-(void)regisonAppkey{

    //注册appkey

    [BRTBeaconSDK registerApp:AppKey onCompletion:^(NSError *error) {

        if (error) {

            UIAlertView *altert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"appkey无效或没有appkey" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

            [altert show];

        }
        
    }];
    
    
    
    
    
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
