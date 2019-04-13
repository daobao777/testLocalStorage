//
//  JCSchoolModel+CoreDataProperties.h
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCSchoolModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JCSchoolModel (CoreDataProperties)

+ (NSFetchRequest<JCSchoolModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t nums;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) NSSet<JCTeacherModel *> *schoolModelT;
@property (nullable, nonatomic, retain) NSSet<JCStudentModel *> *schoolModeS;

@end

@interface JCSchoolModel (CoreDataGeneratedAccessors)

- (void)addSchoolModelTObject:(JCTeacherModel *)value;
- (void)removeSchoolModelTObject:(JCTeacherModel *)value;
- (void)addSchoolModelT:(NSSet<JCTeacherModel *> *)values;
- (void)removeSchoolModelT:(NSSet<JCTeacherModel *> *)values;

- (void)addSchoolModeSObject:(JCStudentModel *)value;
- (void)removeSchoolModeSObject:(JCStudentModel *)value;
- (void)addSchoolModeS:(NSSet<JCStudentModel *> *)values;
- (void)removeSchoolModeS:(NSSet<JCStudentModel *> *)values;

@end

NS_ASSUME_NONNULL_END
