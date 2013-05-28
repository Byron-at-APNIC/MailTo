//
//  NSArray+Mutators.m
//  MailTo
//
//  Created by Byron Ellacott on 28/05/13.
//  Copyright (c) 2013 The Wanderers. All rights reserved.
//

#import "NSArray+Mutators.h"

@implementation NSArray (Mutators)

- (NSArray *)arrayByEnumeratingObjectsUsingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    id *objects = calloc([self count], sizeof(id));
    NSUInteger __block size = 0;
    [self getObjects:objects range:NSMakeRange(0, [self count])];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id newobj = block(obj, idx, stop);
        objects[idx] = newobj;
        size = idx + 1;
    }];
    NSArray *result = [NSArray arrayWithObjects:objects count:size];
    free(objects);
    return result;
}

@end
