//
//  TestClass.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/8.
//  Copyright © 2019 daobao777. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>

@interface TestClass(){
    
}

@end

@implementation TestClass



#pragma mark -NSSecureCoding方法实现
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.test1 forKey:@"test1"];
    [aCoder encodeObject:self.test2 forKey:@"test2"];
    [aCoder encodeObject:self.test3 forKey:@"test3"];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self == [super init]) {
        self.test1 = [aDecoder decodeObjectForKey:@"test1"];
        self.test2 = [aDecoder decodeObjectForKey:@"test2"];
        self.test3 = [aDecoder decodeObjectForKey:@"test3"];
    }
    return self;
}
//加密协议需要实现下面的方法
+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
