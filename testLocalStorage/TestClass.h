//
//  TestClass.h
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/8.
//  Copyright © 2019 daobao777. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestClass : NSObject <NSSecureCoding> //解归档遵守NSCoding协议

@property (nonatomic, assign) NSString *test1;
@property (nonatomic, assign) NSString *test2;
@property (nonatomic, assign) NSString *test3;


@end

NS_ASSUME_NONNULL_END
