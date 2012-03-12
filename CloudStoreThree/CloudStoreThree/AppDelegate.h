//
//  AppDelegate.h
//  CloudStoreThree
//
//  Created by Firoze Lafeer on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) NSUInteger lastMessageRead;

+ (AppDelegate*) instance;
-(void)updateLastMessageRead:(NSUInteger)lastMessageRead;

@end
