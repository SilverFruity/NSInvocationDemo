//
//  NSObject+Invocation.h
//  InvocationDemo
//
//  Created by Jiang on 2020/1/4.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Invocation)
- (nullable id)invocation:(SEL)sel args:(NSArray *)args;
- (nullable id)releaseReturnValueInvocation:(SEL)sel args:(NSArray *)args;
@end

NS_ASSUME_NONNULL_END
