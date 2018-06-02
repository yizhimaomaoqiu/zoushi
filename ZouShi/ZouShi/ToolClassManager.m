//
//  ToolClassManager.m
//  ZouShi
//
//  Created by chengguozhi on 2018/5/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ToolClassManager.h"

@interface ToolClassManager ()
    
    @property (nonatomic, strong)NSMutableArray *numArr;
    
    @end

@implementation ToolClassManager
    
- (CGFloat)blanceNum{
    if (_blanceNum == 0) {
        return 1.0;
    }else{
        return _blanceNum;
    }
}
    
+ (ToolClassManager *)shareDataBase{
    static ToolClassManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return  manager;
}
    
- (void)setDataNum:(NSMutableArray *)arr{
    self.numArr = arr;
}
    
    ///次位 平衡参数计算
- (CGFloat)getBalanceNum:(NSArray *)arr{
    //平衡归类
    NSMutableArray *xiaoyu6 = [NSMutableArray array];
    NSMutableArray *dayu6 = [NSMutableArray array];
    for (NSString *str in arr) {
        if (str.integerValue > 6){
            [dayu6 addObject:str];
        }else if (str.integerValue < 6){
            [xiaoyu6 addObject:str];
        }
    }
    
    CGFloat xiaoyu6num = 0;
    for (NSString *str in xiaoyu6) {
        xiaoyu6num += str.floatValue;
    }
    CGFloat dayu6num = 0;
    for (NSString *str in dayu6) {
        dayu6num += str.floatValue;
    }
    CGFloat xiaoyu6balance = 6.0 - xiaoyu6num / xiaoyu6.count;
    CGFloat dayu6balance = dayu6num / dayu6.count - 6.0;
    
    return dayu6balance - xiaoyu6balance;
}
    
- (NSDictionary *)getBlance:(NSArray *)arr{
    ///1.5 是平衡差距
    return @{
             @"isBlance":fabs([self getBalanceNum:arr]) > self.blanceNum ? @"NO" : @"YES",
             @"num":[NSString stringWithFormat:@"%.2f", [self getBalanceNum:arr]]
             };
}
    
    ///极差
- (NSInteger)getJicha:(NSArray *)tarr{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:tarr];
    for (NSInteger i = 0; i < arr.count; i ++) {
        for (NSInteger j = 0; j < arr.count - 1; j ++) {
            NSString *jstr = arr[j];
            NSString *str = arr[j + 1];
            if (jstr.integerValue < str.integerValue) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return [(NSString *)[arr firstObject] integerValue] - [(NSString *)[arr lastObject] integerValue];
}
    
    ///次位极差
- (NSInteger)getCiweiJicha:(NSArray *)tarr{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:tarr];
    for (NSInteger i = 0; i < arr.count; i ++) {
        for (NSInteger j = 0; j < arr.count - 1; j ++) {
            NSString *jstr = arr[j];
            NSString *str = arr[j + 1];
            if (jstr.integerValue < str.integerValue) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return [(NSString *)arr[1] integerValue] - [(NSString *)arr[3] integerValue];
}
    
//取两个数组的交集
- (NSArray *)getJiaoJiarr1:(NSArray *)arr1 arr2:(NSArray *)arr2{
    NSMutableSet *set1 = [NSMutableSet setWithArray:arr1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:arr2];
    [set1 intersectSet:set2];
    NSArray *jiaoji = [set1 allObjects];
    return jiaoji == nil ? @[] : jiaoji;
}
    
- (NSInteger)getZhongWeiCha:(NSArray *)tarr{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:tarr];
    for (NSInteger i = 0; i < arr.count; i ++) {
        for (NSInteger j = 0; j < arr.count - 1; j ++) {
            NSString *jstr = arr[j];
            NSString *str = arr[j + 1];
            if (jstr.integerValue < str.integerValue) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return [(NSString *)arr[2] integerValue] - 6;
}
    
- (CGFloat)pingJunZhi:(NSArray *)arr{
    CGFloat he = 0.0;
    for (NSString *str in arr) {
        he += str.floatValue;
    }
    return he / arr.count;
}
    
- (NSDictionary *)getBlanceMessageDic{
    if (!self.numArr){
        return nil;
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    NSInteger blance = 0;
    NSInteger blanceAndJicha = 0;
    NSInteger noblance = 0;
    NSInteger noblanceAndJicha = 0;
    NSInteger jichayuchemingzhong = 0;
    NSInteger pinghengyuchemingzhong = 0;
    for (NSInteger i = 0; i < self.numArr.count; i ++) {
        @autoreleasepool{
            
            NSArray *Narr = self.numArr[i];
            NSDictionary *dic = [self getBlance:Narr];
            BOOL isBlance = [dic[@"isBlance"] boolValue];
            NSString *jicha = [NSString stringWithFormat:@"%zd", [self getJicha:Narr]];
            NSString *ciweijicha = [NSString stringWithFormat:@"%zd", [self getCiweiJicha:Narr]];
            NSString *zhongweicha = [NSString stringWithFormat:@"%zd", [self getZhongWeiCha:Narr]];
            BOOL isclude = NO;
            BOOL jichamingzhong = NO;
            NSInteger tjicayuce = -10000;
            BOOL pingHengMingZhong = NO;
            NSInteger tpingHengYuCe = -10000;
            NSArray *jiaoji = nil;
            if (i - 1 >= 0){
                NSArray *arr = self.numArr[i - 1];
                isclude = [arr containsObject:jicha];
                NSInteger jichayuce = [self JiChaForecast:Narr];
                jichamingzhong = [arr containsObject:[NSString stringWithFormat:@"%zd", jichayuce]];
                tjicayuce = jichayuce;
                NSInteger pingHengYuCe = [self blanceForecast:Narr];
                pingHengMingZhong = [arr containsObject:[NSString stringWithFormat:@"%zd", pingHengYuCe]];
                tpingHengYuCe = pingHengYuCe;
                jiaoji = [self getJiaoJiarr1:arr arr2:Narr];
            }
            [dataArr addObject:@{@"arr":Narr,
                                 @"极差":jicha,
                                 @"次位极差":ciweijicha,
                                 @"平衡":isBlance == YES ? @"平衡" : @"不平衡",
                                 @"平衡值":dic[@"num"],
                                 @"包含极差":isclude == YES ? @"包含" : @"不包含",
                                 @"中位差":zhongweicha,
                                 @"平均数":[NSString stringWithFormat:@"%.3f", [self pingJunZhi:Narr]],
                                 @"极差预测":jichamingzhong == YES ? @"命中" : @"没命中",
                                 @"极差预测结果":[NSString stringWithFormat:@"%zd", tjicayuce],
                                 @"平衡预测":pingHengMingZhong == YES ? @"命中" : @"没命中",
                                 @"平衡预测结果":[NSString stringWithFormat:@"%zd", tpingHengYuCe],
                                 @"与下次的交集":jiaoji == nil ? @[] : jiaoji,
                                 @"与下次的交集个数":[NSString stringWithFormat:@"%zd", jiaoji.count]
                                 }];
            if (jichamingzhong) {
                jichayuchemingzhong ++;
            }
            if (pingHengMingZhong){
                pinghengyuchemingzhong++;
            }
            isBlance ? blance ++ : noblance ++;
            if (isBlance == YES && isclude == YES){
                blanceAndJicha++;
            }
            if (isBlance == NO && isclude == YES){
                noblanceAndJicha++;
            }
            
        }
    }
    
    return @{@"messageArr":dataArr,
             @"平衡率":[NSString stringWithFormat:@"%.3f", (CGFloat)blance / (CGFloat)self.numArr.count],
             @"不平衡率":[NSString stringWithFormat:@"%.3f", (CGFloat)noblance / (CGFloat)self.numArr.count],
             @"平衡极差率":[NSString stringWithFormat:@"%.3f", (CGFloat)blanceAndJicha / (CGFloat)blance],
             @"不平衡极差率":[NSString stringWithFormat:@"%.3f", (CGFloat)noblanceAndJicha / (CGFloat)noblance],
             @"极差预测命中率":[NSString stringWithFormat:@"%.3f", (CGFloat)jichayuchemingzhong / (CGFloat)self.numArr.count],
             @"平衡预测命中率":[NSString stringWithFormat:@"%.3f", (CGFloat)pinghengyuchemingzhong / (CGFloat)self.numArr.count]
             };
}
    
- (NSDictionary *)getFirstBlanceMessageDic{
    if (!self.numArr){
        return nil;
    }
    NSArray *Narr = self.numArr[0];
    NSDictionary *dic = [self getBlance:Narr];
    BOOL isBlance = [dic[@"isBlance"] boolValue];
    NSString *jicha = [NSString stringWithFormat:@"%zd", [self getJicha:Narr]];
    NSString *ciweijicha = [NSString stringWithFormat:@"%zd", [self getCiweiJicha:Narr]];
    BOOL isclude = [Narr containsObject:jicha];
    NSString *zhongweicha = [NSString stringWithFormat:@"%zd", [self getZhongWeiCha:Narr]];
    return @{@"arr":Narr,
             @"极差":jicha,
             @"次位极差":ciweijicha,
             @"平衡":isBlance == YES ? @"平衡" : @"不平衡",
             @"平衡值":dic[@"num"],
             @"包含极差":isclude == YES ? @"包含" : @"不包含",
             @"中位差":zhongweicha
             };
}
    
    //极差预测
- (NSInteger)JiChaForecast:(NSArray *)arr{
    NSInteger jicha = [self getJicha:arr];
    CGFloat pingjunzhi = [self pingJunZhi:arr];
    NSString *weiyi = [self getBlance:arr][@"num"];
    NSInteger result = -100000;
    if (weiyi.floatValue < 0){
        result = fabs(jicha - [self JinYi:pingjunzhi] + [self JinYi:weiyi.floatValue]);
    }else if (weiyi.floatValue == 0.0){
        result = fabs(jicha - [self JinYi:pingjunzhi] + [self JinYi:weiyi.floatValue]) -1;
    }else{
        result = fabs(jicha - [self JinYi:pingjunzhi]);
    }
    if (result == 0) {
        return 11;
    }else{
        return result;
    }
}

- (NSInteger)blanceForecast:(NSArray *)arr{
    NSInteger jicha = [self getJicha:arr];
    NSInteger ciWeiJiCha = [self getCiweiJicha:arr];
    NSInteger zhongWeiCha = [self getZhongWeiCha:arr];
    CGFloat pingjunzhi = [self pingJunZhi:arr];
    NSString *weiyi = [self getBlance:arr][@"num"];
    NSInteger result = -100000;
    if (weiyi.floatValue < 0){
        result = fabs(jicha - [self JinYi:pingjunzhi] + [self JinYi:weiyi.floatValue]);
    }else if (weiyi.floatValue == 0.0){
        result = fabs(jicha - [self JinYi:pingjunzhi] + [self JinYi:weiyi.floatValue]) -1;
    }else{
        result = fabs(jicha - [self JinYi:pingjunzhi]);
    }
    NSDictionary *tdic = [self getBlance:arr];
    if ([tdic[@"isBlance"] isEqualToString:@"YES"]) {
        if ((((CGFloat)jicha + (CGFloat)ciWeiJiCha + (CGFloat)zhongWeiCha) / 2.0 > pingjunzhi)) {
            return result;
        }else{
            return result + 1;
        }
    }else{
        if ((((CGFloat)jicha + (CGFloat)ciWeiJiCha + (CGFloat)zhongWeiCha - weiyi.floatValue) / 2.0 > pingjunzhi)) {
            return result;
        }else{
            return result + 1;
        }
    }
}


- (NSInteger)JinYi:(CGFloat)num{
    if (num >= 0){
        NSInteger tnum = (NSInteger)num;
        if ((CGFloat)tnum < num){
            return tnum + 1;
        }else{
            return tnum;
        }
    }else{
        CGFloat fnum = 0 - num;
        NSInteger tnum = (NSInteger)fnum;
        if ((CGFloat)tnum < fnum){
            return 0 - (tnum + 1);
        }else{
            return 0 - tnum;
        }
    }
}

- (NSString *)LogArr{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSArray *smallArr in self.numArr) {
        @autoreleasepool{
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:smallArr];
            for (int i = 0; i < muArr.count; i++) {
                for (int j = 0; j < muArr.count - 1 - i; j++) {
                    if ([muArr[j] intValue] < [muArr[j + 1] intValue]) {
                        int tmp = [muArr[j] intValue];
                        muArr[j] = muArr[j + 1];
                        muArr[j + 1] = [NSNumber numberWithInt:tmp];
                    }
                }
            }
            [arr addObject:muArr];
        }
    }
    NSString *json = [self arrayToJSONString:arr];
    return [NSString stringWithFormat:@"{\"data\":%@}", json];
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSMutableAttributedString *)text:(NSString *)text rangeArr:(NSArray *)rangeArr fontArr:(NSArray *)fontArr colorArr:(NSArray *)colorArr
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        for (NSInteger i = 0; i < rangeArr.count; i ++) {
            
            UIFont *font = fontArr[i];
            UIColor *color = colorArr[i];
            NSValue *value = rangeArr[i];
            NSRange rang = [value rangeValue];
            //设置字号
            [str addAttribute:NSFontAttributeName value:font range:rang];
            //设置文字颜色
            [str addAttribute:NSForegroundColorAttributeName value:color range:rang];
        }
        return str;
    }
    
    
    @end
