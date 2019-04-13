//
//  JCSchoolModel+CoreDataProperties.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/11.
//  Copyright © 2019 daobao777. All rights reserved.
//
//

#import "JCSchoolModel+CoreDataProperties.h"

@implementation JCSchoolModel (CoreDataProperties)

+ (NSFetchRequest<JCSchoolModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"JCSchoolModel"];
}

@dynamic name;
@dynamic nums;
@dynamic type;
@dynamic schoolModelT;
@dynamic schoolModeS;

@end
