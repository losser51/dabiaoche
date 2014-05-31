//
//  DBCString.h
//  dabiaoche
//
//  Created by li losser on 5/4/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface NSString (md5)
- (NSString *)md5HexDigest;
@end
