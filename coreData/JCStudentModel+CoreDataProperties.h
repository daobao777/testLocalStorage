//
//  JCStudentModel+CoreDataProperties.h
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCStudentModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JCStudentModel (CoreDataProperties)

+ (NSFetchRequest<JCStudentModel *> *)fetchRequest;

@property (nonatomic) int64_t age;
@property (nullable, nonatomic, copy) NSString *bloodType;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) JCSchoolModel *studentModel;

@end

NS_ASSUME_NONNULL_END
