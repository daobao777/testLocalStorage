//
//  JCStudentModel+CoreDataProperties.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCStudentModel+CoreDataProperties.h"

@implementation JCStudentModel (CoreDataProperties)

+ (NSFetchRequest<JCStudentModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"JCStudentModel"];
}

@dynamic age;
@dynamic bloodType;
@dynamic name;
@dynamic studentModel;

@end
