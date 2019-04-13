//
//  JCTeacherModel+CoreDataProperties.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCTeacherModel+CoreDataProperties.h"

@implementation JCTeacherModel (CoreDataProperties)

+ (NSFetchRequest<JCTeacherModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"JCTeacherModel"];
}

@dynamic age;
@dynamic course;
@dynamic name;
@dynamic teacherModel;

@end
