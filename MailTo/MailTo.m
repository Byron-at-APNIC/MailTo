//
//  MailTo.m
//  MailTo
//
//  Created by Byron Ellacott on 27/05/13.
//  Copyright (c) 2013 The Wanderers. All rights reserved.
//

#import "MailTo.h"
#import <objc/runtime.h>
#import <objc/objc-runtime.h>

#import "NSArray+Mutators.h"

@interface NSObject (MailMethods)

- (id)allRecipients;
- (BOOL)deliverMessage;
- (void)setAddressList:(id)arg1 forHeader:(id)arg2;
- (id)addressListForHeader:(id)arg1;

@end

@interface MailTo ()

@end

@implementation MailTo

#pragma mark -

#define repl(name, sel, block) SEL name = @selector(sel); IMP old_##name = [cbe instanceMethodForSelector:name]; \
    class_replaceMethod(cbe, name, imp_implementationWithBlock(block), \
    method_getTypeEncoding(class_getInstanceMethod(cbe, name)))

+ (void)initialize
{
    IMP imp = [NSClassFromString(@"MVMailBundle") methodForSelector:@selector(registerBundle)];
    imp(self, @selector(registerBundle));
    
    // Swizzle ComposeBackEnd a little
    Class cbe = NSClassFromString(@"ComposeBackEnd");
    
    const NSDictionary *replacements = @{
        @"Some Name <some@example.com>": @"Replacement Name <replaced@newdomain.example.com"
    };

    repl(sh, deliverMessage, ^(id _self) {
        for (NSString *header in @[@"To", @"Cc", @"Bcc"]) {
            NSArray *addresses = [_self addressListForHeader:header];
            addresses = [addresses arrayByEnumeratingObjectsUsingBlock:^id(id obj, NSUInteger idx, BOOL *stop) {
                NSString *replacement = [replacements objectForKey:obj];
                if (replacement) return replacement;
                return obj;
            }];
            [_self setAddressList:addresses forHeader:header];
        }
        return old_sh(_self, sh);
    });

}

- (id)init
{
    if ((self = [super init]) != nil) {
        NSLog(@"MailTo loaded and ready");
    }

    return self;
}

+ (BOOL)hasComposeAccessoryViewOwner { return NO; }
+ (BOOL)hasPreferencesPanel { return NO; }

#pragma mark - Injection

+ (void)wrapClass:(Class)class instanceMethod:(SEL)sel withBlock:(id (^)(IMP, id, SEL, id, id, id))block
{
    IMP old = [class instanceMethodForSelector:sel];
    class_replaceMethod(class, sel, imp_implementationWithBlock(^(id _self, SEL cmd, id arg1, id arg2, id arg3) {
        return block(old, _self, cmd, arg1, arg2, arg3);
    }), method_getTypeEncoding(class_getInstanceMethod(class, sel)));
}

#pragma mark - pretend to be an MVMailBundle by proxy

+ (id)sharedInstance
{
    IMP imp = [NSClassFromString(@"MVMailBundle") methodForSelector:@selector(sharedInstance)];
    return imp(self, @selector(sharedInstance));
}

- (void)_registerBundleForNotifications
{
    IMP imp = [NSClassFromString(@"MVMailBundle") instanceMethodForSelector:@selector(_registerBundleForNotifications)];
    imp(self, @selector(_registerBundleForNotifications));
}

@end