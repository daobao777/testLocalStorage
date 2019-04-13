//
//  JCCoreDataManager.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/9.
//  Copyright © 2019 daobao777. All rights reserved.
//

#import "JCCoreDataManager.h"

#define JC_CHECK_NSSTRING(str) ((str == nil) || ([str isEqualToString: @""]) || (str == NULL) || ([str isKindOfClass:[NSNull class]]))

@interface JCCoreDataManager(){
    NSString *path;
    NSString *dbFolderPath;
    
    NSError *error;
}

/**
 数据模型
 */
@property (nonatomic, strong) NSManagedObjectModel *objectModel;

/**
 管理数据的对象
 */
@property (nonatomic, strong) NSManagedObjectContext *objectContext;

/**
 持久化数据
 */
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@end

@implementation JCCoreDataManager

static JCCoreDataManager *manager = nil;

#pragma mark - 单例
+ (instancetype)sharedInstanceManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JCCoreDataManager alloc] init];
    });
    return manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //文件路径
        path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        dbFolderPath = [path stringByAppendingPathComponent:@"CoreData"];
        
        NSError *error;
        //创建托管对象模型
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"TestModel" withExtension:@"momd"];
        _objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        //创建持久化协调器
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_objectModel];
        //创建本地数据库文件
        [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self dbPath] options:nil error:&error];
        //创建托管对象上下文
        _objectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_objectContext setPersistentStoreCoordinator:_coordinator];
    }
    return self;
}

/**
 获取数据库路径

 @return NSURL
 */
- (NSURL *)dbPath {
    NSError *error = nil;
    if (![self checkPathExist]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error){
        NSLog(@"创建CoreManager文件失败,error---->%@ \n", error);
        return nil;
    }
    NSURL *dbUrl = [[NSURL fileURLWithPath:dbFolderPath] URLByAppendingPathComponent:@"myDB.sqlite"];
    return dbUrl;
    
}

-(BOOL) checkPathExist{
    return [[NSFileManager defaultManager] fileExistsAtPath:dbFolderPath];
}

#pragma mark - 删除数据库
+ (NSString *)deleteCoreData{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileFolderPath = [documentPath stringByAppendingPathComponent:@"CoreData"];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileFolderPath]){
        [[NSFileManager defaultManager] removeItemAtPath:fileFolderPath error:&error];
    }else{
        return @"没有数据，请先创建";
    }
    if (error){
        return [NSString stringWithFormat:@"删除失败,error--->%@", error];
    }
    return @"删除成功";
    
}

//=============数据库操作===============//
#pragma mark -获取数据模型
+ (NSManagedObject *)getManagedObjectWithEntityName:(NSString *)entityName{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[JCCoreDataManager sharedInstanceManager].objectContext];
    return managedObject;
}
#pragma mark -存储数据
+ (NSString *)save{
    JCCoreDataManager *manager = [JCCoreDataManager sharedInstanceManager];
    if (![manager checkPathExist]) {
        //manager = [[JCCoreDataManager alloc] init];
        [manager.coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[manager dbPath] options:nil error:nil];
    }
    NSError *saveError = nil;
    if ([manager.objectContext save:&saveError]) {
        return @"存储成功";
    }else{
        return [NSString stringWithFormat:@"存储失败，error->%@", saveError];
    };
}

#pragma mark -更新数据
+ (NSString *)updateManagedObject:(NSManagedObject *)managedObject{
    [[JCCoreDataManager sharedInstanceManager].objectContext refreshObject:managedObject mergeChanges:YES];
    return [JCCoreDataManager save];
}

#pragma mark -查找数据

+ (NSArray *)searchCoreDataWithEntityName:(NSString *)entityName andAttribute:(NSString *)attribute andSelectName:(NSString *)searchName sorting:(NSString *)sortAttribute isAsending:(BOOL)isAsending{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[JCCoreDataManager sharedInstanceManager].objectContext];
    //创建fetch请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    //一次获取全部数据
    [fetchRequest setFetchBatchSize:0];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *ageDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    NSSortDescriptor *bloodTypeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bloodType" ascending:YES];
    if (JC_CHECK_NSSTRING(sortAttribute) || ([sortAttribute isEqualToString:@"name"])) {
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortAttribute ascending:isAsending];
        fetchRequest.sortDescriptors = @[nameDescriptor, ageDescriptor, bloodTypeDescriptor];
    }else if ([sortAttribute isEqualToString:@"age"]){
        fetchRequest.sortDescriptors = @[ageDescriptor, nameDescriptor, bloodTypeDescriptor];
    }else{
        fetchRequest.sortDescriptors = @[bloodTypeDescriptor, nameDescriptor, ageDescriptor];
    }
    if (!JC_CHECK_NSSTRING(attribute) && !JC_CHECK_NSSTRING(searchName)) {
        //查找某个属性的值包含某个字符串
        //%K 属性的值     %@ 字符串     ==
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, searchName];
    }
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[JCCoreDataManager sharedInstanceManager].objectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    if ([fetchController performFetch:&error]){
        return [fetchController fetchedObjects];
    }else{
        NSLog(@"%@", error);
        return @[];
    }
    
}

#pragma mark -删除数据
+ (NSString *)deleteWithEntityName:(NSString *)entityName andAttribute:(NSString *)attribute andSearchName:(NSString *)searchName{
    //没有删除条件
    if (JC_CHECK_NSSTRING(attribute) || JC_CHECK_NSSTRING(searchName)) {
        return @"没有删除条件或条件不完整";
    }
    //查找
    NSArray *arr = [JCCoreDataManager searchCoreDataWithEntityName:entityName andAttribute:attribute andSelectName:searchName sorting:attribute isAsending:YES];
    if (arr.count == 0)
        return @"没有找到数据";
    if (arr.count>0) {
        //删除
        for (NSManagedObject *object in arr) {
            [[JCCoreDataManager sharedInstanceManager].objectContext deleteObject:object];
        }
    }
    //存储数据
    [JCCoreDataManager save];
    return @"删除成功";
    
    
}
@end
