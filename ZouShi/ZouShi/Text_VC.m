//
//  Text_VC.m
//  ZouShi
//
//  Created by chengguozhi on 2018/5/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "Text_VC.h"
#import "ToolClassManager.h"
#import "SCChart.h"
@interface Text_VC ()<UITableViewDelegate, UITableViewDataSource, SCChartDataSource>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation Text_VC

- (void)action{
    
    UIAlertController *alC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alC addAction:[UIAlertAction actionWithTitle:@"只看没命中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self meiMingZhong:self.tableView];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"只看命中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self mingZhong:self.tableView];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jisuan:self.tableView];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"数据解析";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:self action:@selector(action)];
    self.navigationItem.rightBarButtonItem = item;
    
    if (self.index == 0){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
        [self jisuan:self.tableView];
        self.tableView.tableHeaderView = [self tableheaderView];
    }
    
    if (self.index == 1){
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 64)];
        [self.view addSubview:textview];
        textview.font = [UIFont systemFontOfSize:15];
        textview.text = [self dictionaryToJson:self.dic];
    }
}

- (UIView *)tableheaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 600)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *tarr = @[[NSString stringWithFormat:@"平衡率:%@\n", self.dic[@"平衡率"]],
                      [NSString stringWithFormat:@"不平衡率:%@\n", self.dic[@"不平衡率"]],
                      [NSString stringWithFormat:@"平衡极差率:%@\n", self.dic[@"平衡极差率"]],
                      [NSString stringWithFormat:@"不平衡极差率:%@\n", self.dic[@"不平衡极差率"]],
                      [NSString stringWithFormat:@"极差预测命中率:%@\n", self.dic[@"极差预测命中率"]],
                      [NSString stringWithFormat:@"平衡预测命中率:%@\n", self.dic[@"平衡预测命中率"]]
                      ];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, view.frame.size.width - 60, 160)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = [tarr componentsJoinedByString:@""];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:17];
    [view addSubview:lab];
    lab.numberOfLines = 0;
    
    SCChart *chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width - 20, 400) withSource:self withStyle:SCChartBarStyle];
    [chartView showInView:view];
    
    return view;
}
    
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
}
    
- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
    NSDictionary *dic = self.dic[@"分布字典"];
    NSMutableArray *arr = [NSMutableArray array];
    if (dic.count > 0){
        for (NSInteger i = 1; i < 12; i++) {
            NSString *istr = [NSString stringWithFormat:@"%zd", i];
            [arr addObject:dic[istr]];
        }
        return @[arr];
    }
    return @[];
}

- (void)meiMingZhong:(UITableView *)tableview{
    self.dataArr = [NSMutableArray array];
    NSArray *messageArr = self.dic[@"messageArr"];
    for (NSDictionary *dic in messageArr) {
        NSArray *arr = dic[@"arr"];
        if ([dic[@"极差预测"] isEqualToString:@"没命中"]) {
            NSArray *tarr = @[[NSString stringWithFormat:@"平衡状态:%@\n", dic[@"平衡"]],
                              [NSString stringWithFormat:@"平衡位移:%@\n", dic[@"平衡值"]],
                              [NSString stringWithFormat:@"极差:%@\n", dic[@"极差"]],
                              [NSString stringWithFormat:@"次位极差:%@\n", dic[@"次位极差"]],
                              [NSString stringWithFormat:@"中位差:%@\n", dic[@"中位差"]],
                              [NSString stringWithFormat:@"是否包含上次极差:%@\n", dic[@"包含极差"]],
                              [NSString stringWithFormat:@"平均值:%@\n", dic[@"平均数"]],
                              [NSString stringWithFormat:@"与下次的交集:%@\n", [dic[@"与下次的交集"] componentsJoinedByString:@","]],
                              [NSString stringWithFormat:@"与下次的交集个数:%@\n", dic[@"与下次的交集个数"]],
                              [NSString stringWithFormat:@"极差预测:%@\n", dic[@"极差预测"]],
                              [NSString stringWithFormat:@"极差预测结果:%@\n", dic[@"极差预测结果"]],
                              [NSString stringWithFormat:@"平衡预测:%@\n", dic[@"平衡预测"]],
                              [NSString stringWithFormat:@"平衡预测结果:%@\n", dic[@"平衡预测结果"]]
                              ];
            NSMutableArray *colorArr = [NSMutableArray array];
            NSMutableArray *fontArr = [NSMutableArray array];
            NSMutableArray *rangArr = [NSMutableArray array];
            NSInteger le = 0;
            for (NSInteger i = 0; i < tarr.count; i ++) {
                NSString *str = tarr[i];
                if (i == tarr.count - 1){
                    [colorArr addObject:[UIColor orangeColor]];
                }else if (i == tarr.count - 2){
                    [colorArr addObject:[UIColor redColor]];
                }else if (i == tarr.count - 3){
                    [colorArr addObject:[UIColor greenColor]];
                }else if (i == tarr.count - 4){
                    [colorArr addObject:[UIColor purpleColor]];
                }else if (i == tarr.count - 5){
                    [colorArr addObject:[UIColor redColor]];
                }else if (i == tarr.count - 6){
                    [colorArr addObject:[UIColor orangeColor]];
                }else{
                    [colorArr addObject:[UIColor lightGrayColor]];
                }
                [fontArr addObject:[UIFont systemFontOfSize:15]];
                [rangArr addObject:[NSValue valueWithRange:NSMakeRange(le, str.length)]];
                le += str.length;
            }
            [self.dataArr addObject:@{@"title":[arr componentsJoinedByString:@","],
                                      @"subtitle":[[ToolClassManager shareDataBase]text:[tarr componentsJoinedByString:@""]
                                                                               rangeArr:rangArr
                                                                                fontArr:fontArr
                                                                               colorArr:colorArr]
                                      }];
        }
    }
    [tableview reloadData];
}

- (void)mingZhong:(UITableView *)tableview{
    self.dataArr = [NSMutableArray array];
    NSArray *messageArr = self.dic[@"messageArr"];
    for (NSDictionary *dic in messageArr) {
        NSArray *arr = dic[@"arr"];
        if ([dic[@"极差预测"] isEqualToString:@"命中"]) {
            NSArray *tarr = @[[NSString stringWithFormat:@"平衡状态:%@\n", dic[@"平衡"]],
                              [NSString stringWithFormat:@"平衡位移:%@\n", dic[@"平衡值"]],
                              [NSString stringWithFormat:@"极差:%@\n", dic[@"极差"]],
                              [NSString stringWithFormat:@"次位极差:%@\n", dic[@"次位极差"]],
                              [NSString stringWithFormat:@"中位差:%@\n", dic[@"中位差"]],
                              [NSString stringWithFormat:@"是否包含上次极差:%@\n", dic[@"包含极差"]],
                              [NSString stringWithFormat:@"平均值:%@\n", dic[@"平均数"]],
                              [NSString stringWithFormat:@"与下次的交集:%@\n", [dic[@"与下次的交集"] componentsJoinedByString:@","]],
                              [NSString stringWithFormat:@"与下次的交集个数:%@\n", dic[@"与下次的交集个数"]],
                              [NSString stringWithFormat:@"极差预测:%@\n", dic[@"极差预测"]],
                              [NSString stringWithFormat:@"极差预测结果:%@\n", dic[@"极差预测结果"]],
                              [NSString stringWithFormat:@"平衡预测:%@\n", dic[@"平衡预测"]],
                              [NSString stringWithFormat:@"平衡预测结果:%@\n", dic[@"平衡预测结果"]]
                              ];
            NSMutableArray *colorArr = [NSMutableArray array];
            NSMutableArray *fontArr = [NSMutableArray array];
            NSMutableArray *rangArr = [NSMutableArray array];
            NSInteger le = 0;
            for (NSInteger i = 0; i < tarr.count; i ++) {
                NSString *str = tarr[i];
                if (i == tarr.count - 1){
                    [colorArr addObject:[UIColor orangeColor]];
                }else if (i == tarr.count - 2){
                    [colorArr addObject:[UIColor redColor]];
                }else if (i == tarr.count - 3){
                    [colorArr addObject:[UIColor greenColor]];
                }else if (i == tarr.count - 4){
                    [colorArr addObject:[UIColor purpleColor]];
                }else if (i == tarr.count - 5){
                    [colorArr addObject:[UIColor redColor]];
                }else if (i == tarr.count - 6){
                    [colorArr addObject:[UIColor orangeColor]];
                }else{
                    [colorArr addObject:[UIColor lightGrayColor]];
                }
                [fontArr addObject:[UIFont systemFontOfSize:15]];
                [rangArr addObject:[NSValue valueWithRange:NSMakeRange(le, str.length)]];
                le += str.length;
            }
            [self.dataArr addObject:@{@"title":[arr componentsJoinedByString:@","],
                                      @"subtitle":[[ToolClassManager shareDataBase]text:[tarr componentsJoinedByString:@""]
                                                                               rangeArr:rangArr
                                                                                fontArr:fontArr
                                                                               colorArr:colorArr]
                                      }];
        }
    }
    [tableview reloadData];
}

- (void)jisuan:(UITableView *)tableview{
    self.dataArr = [NSMutableArray array];
    NSArray *messageArr = self.dic[@"messageArr"];
    for (NSDictionary *dic in messageArr) {
        NSArray *arr = dic[@"arr"];
        NSArray *tarr = @[[NSString stringWithFormat:@"平衡状态:%@\n", dic[@"平衡"]],
                          [NSString stringWithFormat:@"平衡位移:%@\n", dic[@"平衡值"]],
                          [NSString stringWithFormat:@"极差:%@\n", dic[@"极差"]],
                          [NSString stringWithFormat:@"次位极差:%@\n", dic[@"次位极差"]],
                          [NSString stringWithFormat:@"中位差:%@\n", dic[@"中位差"]],
                          [NSString stringWithFormat:@"是否包含上次极差:%@\n", dic[@"包含极差"]],
                          [NSString stringWithFormat:@"平均值:%@\n", dic[@"平均数"]],
                          [NSString stringWithFormat:@"与下次的交集:%@\n", [dic[@"与下次的交集"] componentsJoinedByString:@","]],
                          [NSString stringWithFormat:@"与下次的交集个数:%@\n", dic[@"与下次的交集个数"]],
                          [NSString stringWithFormat:@"极差预测:%@\n", dic[@"极差预测"]],
                          [NSString stringWithFormat:@"极差预测结果:%@\n", dic[@"极差预测结果"]],
                          [NSString stringWithFormat:@"平衡预测:%@\n", dic[@"平衡预测"]],
                          [NSString stringWithFormat:@"平衡预测结果:%@\n", dic[@"平衡预测结果"]]
                          ];
        NSMutableArray *colorArr = [NSMutableArray array];
        NSMutableArray *fontArr = [NSMutableArray array];
        NSMutableArray *rangArr = [NSMutableArray array];
        NSInteger le = 0;
        for (NSInteger i = 0; i < tarr.count; i ++) {
            NSString *str = tarr[i];
            if (i == tarr.count - 1){
                [colorArr addObject:[UIColor orangeColor]];
            }else if (i == tarr.count - 2){
                [colorArr addObject:[UIColor redColor]];
            }else if (i == tarr.count - 3){
                [colorArr addObject:[UIColor greenColor]];
            }else if (i == tarr.count - 4){
                [colorArr addObject:[UIColor purpleColor]];
            }else if (i == tarr.count - 5){
                [colorArr addObject:[UIColor redColor]];
            }else if (i == tarr.count - 6){
                [colorArr addObject:[UIColor orangeColor]];
            }else{
                [colorArr addObject:[UIColor lightGrayColor]];
            }
            [fontArr addObject:[UIFont systemFontOfSize:15]];
            [rangArr addObject:[NSValue valueWithRange:NSMakeRange(le, str.length)]];
            le += str.length;
        }
        [self.dataArr addObject:@{@"title":[arr componentsJoinedByString:@","],
                                  @"subtitle":[[ToolClassManager shareDataBase]text:[tarr componentsJoinedByString:@""]
                                                                           rangeArr:rangArr
                                                                            fontArr:fontArr
                                                                           colorArr:colorArr]
                                  }];
    }
    [tableview reloadData];
    
}
    

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstr];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellstr];
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.attributedText = dic[@"subtitle"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic { NSError *parseError = nil; NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError]; return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
