//
//  NSArray+Mutators.h
//  MailTo
//
//  Created by Byron Ellacott on 28/05/13.
//  Copyright (c) 2013 The Wanderers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Mutators)

- (NSArray *)arrayByEnumeratingObjectsUsingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end
