//
//  NSObject+Invocation.m
//  InvocationDemo
//
//  Created by Jiang on 2020/1/4.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)
- (id)invocation:(SEL)sel args:(NSArray *)args{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    if (!signature) {
        signature = [[self class] methodSignatureForSelector:sel];
    }
    NSAssert(signature, @"signature not exsit, [%@ %@] %@ performArs",self,NSStringFromSelector(sel),[args componentsJoinedByString:@","]);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:sel];
    //参数
    if (args) {
        // self, _cmd, args
        NSAssert(signature.numberOfArguments-2 == args.count, @"%@.performArgs %@ ,The SEL parameters count is not equal to args parameters count. sel need %lu, but args is %lu",self,NSStringFromSelector(sel),(unsigned long)signature.numberOfArguments-2,(unsigned long)args.count);
        for (int i = 0; i < args.count; i++) {
            id obj = args[i];
            [invocation setArgument:&obj atIndex:i+2];
        }
    }
    [invocation retainArguments];
    [invocation invokeWithTarget:self];
    
    //返回值判断，默认认为有返回值的返回的都是对象
    BOOL hasRereturnValue = (*signature.methodReturnType) == '@';
    id returnValue = nil;
    if (hasRereturnValue) {
        [invocation getReturnValue:&returnValue];
        const char * returnType = [signature methodReturnType];
        //TODO: 解决在swift中，获取到值，直接被release的情况
        if (self.isSwift && returnValue && strcmp(returnType, @encode(id)) == 0){
            CFRetain((__bridge CFTypeRef)returnValue);
        }
    }
    return returnValue;
}

- (id)releaseReturnValueInvocation:(SEL)sel args:(NSArray *)args{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    if (!signature) {
        signature = [[self class] methodSignatureForSelector:sel];
    }
    NSAssert(signature, @"signature not exsit, [%@ %@] %@ performArs",self,NSStringFromSelector(sel),[args componentsJoinedByString:@","]);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:sel];
    //参数
    if (args) {
        // self, _cmd, args
        NSAssert(signature.numberOfArguments-2 == args.count, @"%@.performArgs %@ ,The SEL parameters count is not equal to args parameters count. sel need %lu, but args is %lu",self,NSStringFromSelector(sel),(unsigned long)signature.numberOfArguments-2,(unsigned long)args.count);
        for (int i = 0; i < args.count; i++) {
            id obj = args[i];
            [invocation setArgument:&obj atIndex:i+2];
        }
    }
    [invocation retainArguments];
    [invocation invokeWithTarget:self];
    
    //返回值判断，默认认为有返回值的返回的都是对象
    BOOL hasRereturnValue = (*signature.methodReturnType) == '@';
    id returnValue = nil;
    if (hasRereturnValue) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}
- (BOOL)isSwift{
    return [NSStringFromClass([self class]) componentsSeparatedByString:@"."].count > 1;
}
@end
