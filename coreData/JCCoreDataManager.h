//
//  JCCoreDataManager.h
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/9.
//  Copyright © 2019 daobao777. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCCoreDataManager : NSObject

/**
 单例

 @return JCCoreDataManager
 */
+(instancetype)sharedInstanceManager;

/**
 删除数据库
 */
+(NSString *)deleteCoreData;

#pragma mark - 数据库增删改查
+(NSManagedObject *)getManagedObjectWithEntityName:(NSString *)entityName;

+(NSString *)save;

+(NSString *)deleteWithEntityName : (NSString *) entityName
               andAttribute : (NSString *) attribute
              andSearchName : (NSString *) searchName;

+(NSString *)updateManagedObject : (NSManagedObject*) managedObject;


/**
 查找数据

 @param entityName select entity name
 @param attribute attribute's string
 @param searchName <#searchName description#>
 @param sortAttribute <#sortAttribute description#>
 @param isAsending Whether asending the data.
 @return data array
 */
+(NSArray *)searchCoreDataWithEntityName : (NSString *) entityName
                            andAttribute : (NSString *) attribute
                           andSelectName : (NSString *) searchName
                                 sorting : (NSString *) sortAttribute
                              isAsending : (BOOL) isAsending;

@end

NS_ASSUME_NONNULL_END
