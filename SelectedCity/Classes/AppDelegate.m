//
//  AppDelegate.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 25.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "AppDelegate.h"
#import "PSGCountryTVC.h"
#import "PSGFavoritesVC.h"
#import "PSGSettingsVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    PSGCountryTVC *country = [[PSGCountryTVC alloc] initWithStyle:UITableViewStylePlain];
    country.tabBarItem.image = [UIImage imageNamed:@"im_country"];
    country.tabBarItem.title = @"Страны";
    
    PSGFavoritesVC *favorites = [[PSGFavoritesVC alloc] init];
    favorites.tabBarItem.image = [UIImage imageNamed:@"im_favorites"];
    favorites.tabBarItem.title = @"Избранное";
    
    PSGSettingsVC *settings = [[PSGSettingsVC alloc] init];
    settings.tabBarItem.image = [UIImage imageNamed:@"im_settings"];
    settings.tabBarItem.title = @"Настройки";
    
    UINavigationController *countryNC = [[UINavigationController alloc] initWithRootViewController:country];
    UINavigationController *favoritesNC = [[UINavigationController alloc] initWithRootViewController:favorites];
    UINavigationController *settingsNC = [[UINavigationController alloc] initWithRootViewController:settings];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:countryNC, favoritesNC, settingsNC, nil];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
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
    // Saves changes in the application's managed object context before the application terminates.
    [[PSGCoreDataAPI sharedCoreDataAPI] saveContext];
}

@end
