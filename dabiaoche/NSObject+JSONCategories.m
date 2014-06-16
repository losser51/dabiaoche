//
//  NSObject+JSONCategories.m
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)

-(NSData*)JSONString;
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
