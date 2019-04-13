//
//  ViewController.m
//  testLocalStorage
//
//  Created by daobao777 on 2019/4/8.
//  Copyright © 2019 daobao777. All rights reserved.
//

#import "ViewController.h"

#define ATTRIBUTE @"attrubute"
#define SORT_ATTRIBUTE @"sortAttribute"

@interface ViewController ()<LMJDropdownMenuDelegate>{
    NSArray *attributeMenuTitles;
    NSString *attribute;
    NSString *sortAttribute;
    
}

@property (strong, nonatomic) IBOutlet UILabel *modelTypeLabel;

@property (strong, nonatomic) IBOutlet UILabel *attributeLabel;

@property (strong, nonatomic) IBOutlet UILabel *searchKeyWordsLabel;

@property (strong, nonatomic) IBOutlet UITextField *keyWordsTextField;

@property (strong, nonatomic) IBOutlet UILabel *sortAttributeLabel;

@property (strong, nonatomic) IBOutlet UITextView *resultTextView;


@end

@implementation ViewController

//增加按钮
- (IBAction)addSomeStudentModelBtnClicked:(UIButton *)sender {
    for (int i = 0; i<10; i++) {
        JCStudentModel *studentModel = (JCStudentModel *)[JCCoreDataManager getManagedObjectWithEntityName:NSStringFromClass([JCStudentModel class])];
        uint32_t r = arc4random_uniform(99)+1;
        studentModel.name = [NSString stringWithFormat:@"student%@", r<10?[NSString stringWithFormat:@"0%u", r]:[NSString stringWithFormat:@"%u", r]];
        studentModel.age = arc4random_uniform(8)+10;
        studentModel.bloodType = arc4random_uniform(101)>50?@"A":@"B";
       
    }
    NSString *ans = [JCCoreDataManager save];
    if ([ans isEqualToString:@"存储成功"]){
        _resultTextView.text = @"数据创建成功";
    }else{
        _resultTextView.text = [NSString stringWithFormat:@"数据创建失败, %@", ans];
    };
    
}
//删除所有数据
- (IBAction)deleteStudentModelBtnClicked:(UIButton *)sender {
    _resultTextView.text = [JCCoreDataManager deleteCoreData];
}

//查找按钮
- (IBAction)searchStudentModelBtnClicked:(id)sender {
    NSString *selectName = _keyWordsTextField.text;
    NSArray *a = [JCCoreDataManager searchCoreDataWithEntityName:NSStringFromClass([JCStudentModel class]) andAttribute:attribute  andSelectName:selectName sorting:sortAttribute isAsending:YES];
    NSLog(@"a.count = %lu", (unsigned long)a.count);
    _resultTextView.text = @" \n";
    for (JCStudentModel *s in a) {
        NSLog(@"%@, %lld, %@", s.name, s.age, s.bloodType);
        _resultTextView.text = [_resultTextView.text stringByAppendingString:[NSString stringWithFormat:@"name = %@, age = %lld, bloodType = %@ \n", s.name, s.age, s.bloodType]];
    }
}
//条件删除按钮
- (IBAction)deleteSomeDataBtnClicked:(UIButton *)sender {
    _resultTextView.text = [JCCoreDataManager deleteWithEntityName:NSStringFromClass([JCStudentModel class]) andAttribute:attribute andSearchName:_keyWordsTextField.text];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //UserDefualt
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithObjects:@"1", @"2", nil];
    NSArray *arr = [NSArray array];
    //1.UserDefualt存储数据
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"myData"];
    arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"myData"];
    NSLog(@"arr = %@ \n", arr);
    
    [mutArr addObject:@"3"];
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"myData"];
    arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"myData"];
    NSLog(@"arr = %@ \n", arr);
    
    //2.plist文件操作
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"testLocalStorageData.plist"];
    NSLog(@"path = %@ \n", path);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:path contents:nil attributes:nil];
    //写入
    NSDictionary *dic = @{@"value1":@"key1", @"value2":@"key2"};
    [dic writeToFile:path atomically:YES];
    //读出
    NSDictionary *dicc = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"dicc = %@ \n", dicc);
    
    //3.解归档(能够存储自定义对象)
    TestClass *myclass = [TestClass new];
    myclass.test1 = @"123";
    myclass.test2 = @"456";
    myclass.test3 = @"789";
    NSLog(@"myclass = %@", myclass.test1);
    NSString *archPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *archFilePath = [archPath stringByAppendingPathComponent:@"archData.data"];
    NSLog(@"----------%@", NSStringFromClass(myclass.class));
    NSError *error;
    //iOS12.0弃用
    //[NSKeyedArchiver archiveRootObject:myclass toFile:archFilePath];
    //归档
    NSData *archData = [NSKeyedArchiver archivedDataWithRootObject:myclass requiringSecureCoding:YES error:&error];
    NSLog(@"archData = %@", archData);
    if (error) {
        NSLog(@"archError : %@", error);
    }else{
        [archData writeToFile:archFilePath atomically:YES];
    }
    //解档
    NSData *unarch = [[NSData alloc] initWithContentsOfFile:archFilePath];
    TestClass *content = [NSKeyedUnarchiver unarchivedObjectOfClass:NSClassFromString(@"TestClass") fromData:unarch error:&error];
    if (error){
        NSLog(@"unarchError->%@", error);
    }else{
        NSLog(@"content = %@", content.test1);
    }
    
    //4.CoreData
    
    //选择框初始化
    LMJDropdownMenu *attributeMenu = [[LMJDropdownMenu alloc]init];
    attributeMenu.frame = CGRectMake(CGRectGetMaxX(_attributeLabel.frame)+5, CGRectGetMinY(_attributeLabel.frame), 100, 25);
    attributeMenuTitles = @[@"name", @"age", @"bloodType"];
    [attributeMenu setMenuTitles:attributeMenuTitles rowHeight:25 name:ATTRIBUTE];
    attributeMenu.delegate = self;
    [self.view addSubview:attributeMenu];
    LMJDropdownMenu *sortAttributeMenu = [[LMJDropdownMenu alloc]init];
    sortAttributeMenu.frame = CGRectMake(CGRectGetMaxX(_attributeLabel.frame)+5, CGRectGetMinY(_sortAttributeLabel.frame), 120, 25);
    [sortAttributeMenu setMenuTitles:attributeMenuTitles rowHeight:25 name:SORT_ATTRIBUTE];
    sortAttributeMenu.delegate = self;
    [self.view addSubview:sortAttributeMenu];
    
    
}

#pragma mark -LMJDropdownMenuDelegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%@",attributeMenuTitles[number]);
    if ([menu.name isEqualToString:ATTRIBUTE]) {
        attribute = attributeMenuTitles[number];
        NSLog(@"attribute = %@", attribute);
    }else if ([menu.name isEqualToString:SORT_ATTRIBUTE]){
        sortAttribute = attributeMenuTitles[number];
        NSLog(@"sortAttribute = %@", sortAttribute);
    }
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}


@end
