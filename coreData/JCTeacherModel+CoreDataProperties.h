//
//  JCTeacherModel+CoreDataProperties.h
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCTeacherModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JCTeacherModel (CoreDataProperties)

+ (NSFetchRequest<JCTeacherModel *> *)fetchRequest;

@property (nonatomic) int64_t age;
@property (nullable, nonatomic, copy) NSString *course;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) JCSchoolModel *teacherModel;

@end

NS_ASSUME_NONNULL_END
