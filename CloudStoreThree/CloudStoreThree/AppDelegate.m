//
//  AppDelegate.m
//  CloudStoreThree
//
//  Created by Firoze Lafeer on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

NSString * const kKeyLastMessageRead = @"LastMessageRead";

@interface AppDelegate()

@property (nonatomic, assign) NSUInteger lastMessageRead;

-(void)postToCloudLastMessageRead:(NSUInteger)lastMessageRead;


@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize lastMessageRead = lastMessageRead_;

-(void)updateLastMessageRead:(NSUInteger)lastMessageRead {
    
    self.lastMessageRead = lastMessageRead; // This will update our local userdefaults
    
    [self postToCloudLastMessageRead:lastMessageRead];
    
    NSLog(@"APP: User Updates Last Message Read: %d",lastMessageRead);

}

-(void)postToCloudLastMessageRead:(NSUInteger)lastMessageRead {
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
    [store setLongLong:lastMessageRead forKey:kKeyLastMessageRead];
    
    NSLog(@"APP: Posting New Last Message Read to store: %@ value: %d",store,lastMessageRead);

}

-(void)cloudDidUpdateLastMessageRead:(NSNotification*)note  {
    
    NSNumber *reasonForChange = [[note userInfo] objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    NSInteger reason = [reasonForChange integerValue];
    
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        
        // If something is changing externally, get the changes
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        
        // In real life, we'd probably want to check to see that this 
        // is the key that changed
        NSNumber *newMessageRead = [store objectForKey:kKeyLastMessageRead];
        
        if (newMessageRead) {
            
            self.lastMessageRead = [newMessageRead longValue];
        }
        
        NSLog(@"SERVER: Last Message Read Updated to %d",self.lastMessageRead);
        
    }
}

-(void)writeLastMessageReadLocally {
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSNumber numberWithLong:self.lastMessageRead] forKey:kKeyLastMessageRead];
    
    [userDefaults synchronize];
    
    NSLog(@"APP: Local Last Message Read Updated to %d",self.lastMessageRead);
}

-(void)observeValueForKeyPath:(NSString *)keyPath 
                     ofObject:(id)object 
                       change:(NSDictionary *)change 
                      context:(void *)context {
    
    if ((object == self) && [keyPath isEqualToString:@"lastMessageRead"]) {
        
        //Write the new value out to the user defaults
        [self writeLastMessageReadLocally];
    }
    
    else { [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Read the saved value for lastMessageRead
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSNumber *savedValue = [userDefaults objectForKey:kKeyLastMessageRead]; 
    
    self.lastMessageRead = savedValue ? [savedValue longValue] : 0;
    
    // Make sure we write any changes to lastMessageRead back out to the 
    // local user defaults
    
    [self addObserver:self 
           forKeyPath:@"lastMessageRead" 
              options:NSKeyValueObservingOptionNew 
              context:nil];
    
    // Register for updates from iCloud...
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cloudDidUpdateLastMessageRead:) 
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification 
                                               object:nil];
    
     
    [store synchronize];
    return YES;
}

+(AppDelegate*) instance {
    
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
