//
//  ViewController.m
//  ZouShi
//
//  Created by admin on 18/1/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import "NumTab_cell.h"
#import "SVProgressHUD.h"
#import "ToolClassManager.h"
#import "Text_VC.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UITableView *tableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"数据";
    
    self.dataArr = [NSMutableArray array];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:self action:@selector(gongneng)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = item1;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self read];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"NumTab_cell";
    NumTab_cell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[NumTab_cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *arr = self.dataArr[indexPath.row];
    [cell setTextArr:arr];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
    UITableViewRowAction *row1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    UITableViewRowAction *row2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"向上插入" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self pop:indexPath.row];
    }];
    UITableViewRowAction *row3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"向下插入" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self pop:indexPath.row + 1];
    }];
    row1.backgroundColor = [UIColor redColor];
    row2.backgroundColor = [UIColor blueColor];
    row3.backgroundColor = [UIColor orangeColor];
    return @[row1, row2, row3];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)pop:(NSInteger)index{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"填写数字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType =  UIKeyboardTypeNumberPad;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *arr= [NSMutableArray array];
        for (UITextField *textFie in alertController.textFields) {
            [arr addObject:textFie.text];
        }
        [self pailie:arr index:index];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)pailie:(NSArray *)arr index:(NSInteger)index{
    NSMutableArray *darr = [NSMutableArray array];
    for (NSInteger i = 1; i <= 11; i ++) {
        if ([arr containsObject:[NSString stringWithFormat:@"%zd", i]]) {
            [darr addObject:[NSString stringWithFormat:@"%zd", i]];
        }else{
            [darr addObject:@""];
        }
    }
    [self.dataArr insertObject:arr atIndex:index];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)gongneng{
    UIAlertController *alC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alC addAction:[UIAlertAction actionWithTitle:@"写入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.dataArr.count > 0) {
            [self write:self.dataArr];
        }else{
            [SVProgressHUD showErrorWithStatus:@"不能写入"];
        }
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"读取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.dataArr = [self read];
        [self.tableView reloadData];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alC = [UIAlertController alertControllerWithTitle:@"确定清空所有信息吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clear];
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"已删除所有数据"];
        }]];
        [alC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alC animated:YES completion:nil];
        
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"全部平衡字典" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToolClassManager shareDataBase]setDataNum:self.dataArr];
        Text_VC *vc = [[Text_VC alloc]init];
        vc.index = 0;
        vc.dic = [[ToolClassManager shareDataBase]getBlanceMessageDic];
        [self.navigationController pushViewController:vc animated:YES];
        
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"最新平衡字典" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToolClassManager shareDataBase]setDataNum:self.dataArr];
        Text_VC *vc = [[Text_VC alloc]init];
        vc.index = 1;
        vc.dic = [[ToolClassManager shareDataBase]getFirstBlanceMessageDic];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"打印数组json, 并复制到粘贴板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToolClassManager shareDataBase]setDataNum:self.dataArr];
        NSString *str = [[ToolClassManager shareDataBase] LogArr];
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = str;
        NSLog(@"%@", str);
        UIAlertController *talC = [UIAlertController alertControllerWithTitle:@"json" message:str preferredStyle:UIAlertControllerStyleAlert];
        [talC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:talC animated:YES completion:nil];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"预测结果" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSInteger jicha = [[ToolClassManager shareDataBase]JiChaForecast:self.dataArr.firstObject];
        NSInteger pengheng = [[ToolClassManager shareDataBase]blanceForecast:self.dataArr.firstObject];
        NSString *str1 = [NSString stringWithFormat:@"极差预测结果: %ld", (long)jicha];
        NSString *str2 = [NSString stringWithFormat:@"平衡预测结果: %ld", (long)pengheng];
        NSArray *arr = @[str1, str2];
        UIAlertController *talC = [UIAlertController alertControllerWithTitle:@"预测" message:[arr componentsJoinedByString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
        [talC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:talC animated:YES completion:nil];
    }]];
    
    
    [alC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alC animated:YES completion:nil];
}


- (void)write:(NSMutableArray *)arr{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:arr forKey:@"data"];
    [userdefaults synchronize];
}

- (NSMutableArray *)read{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userdefaults objectForKey:@"data"];
    if (!arr) {
        return [NSMutableArray array];
    }else{
        return [NSMutableArray arrayWithArray:arr];
    }
}

- (void)clear{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults removeObjectForKey:@"data"];
    [userdefaults synchronize];
    [self.dataArr removeAllObjects];
    
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}




- (void)add{
    [self pop:0];
}
















@end
