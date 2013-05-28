//
//  MVMailBundle.h
//  MailTo
//
//  Created by Byron Ellacott on 27/05/13.
//  Copyright (c) 2013 The Wanderers. All rights reserved.
//

@protocol MVMessageDisplayNotifications

@optional
- (void)messageWillBeDisplayedInView:(id)arg1;
@end

@interface MVMailBundle : NSObject <MVMessageDisplayNotifications>
{
}

+ (id)composeAccessoryViewOwnerClassName;
+ (BOOL)hasComposeAccessoryViewOwner;
+ (id)preferencesPanelName;
+ (id)preferencesOwnerClassName;
+ (BOOL)hasPreferencesPanel;
+ (id)sharedInstance;
+ (void)registerBundle;
+ (id)composeAccessoryViewOwners;
+ (id)allBundles;
- (void)_registerBundleForNotifications;
- (void)dealloc;

@end
