//
//  ToolClassManager.h
//  ZouShi
//
//  Created by chengguozhi on 2018/5/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolClassManager : NSObject

///平衡差距参数, 默认1.5
@property (nonatomic, assign)CGFloat blanceNum;

+ (ToolClassManager *)shareDataBase;

- (void)setDataNum:(NSMutableArray *)arr;

///获取全部平衡字典
- (NSDictionary *)getBlanceMessageDic;

///获取全部最新字典
- (NSDictionary *)getFirstBlanceMessageDic;

//极差预测
- (NSInteger)JiChaForecast:(NSArray *)arr;

//平衡预测
- (NSInteger)blanceForecast:(NSArray *)arr;

///返回数组json数据
- (NSString *)LogArr;
    
///红球算法
- (NSArray *)getHongQiu:(NSArray *)arr;

-(NSMutableAttributedString *)text:(NSString *)text rangeArr:(NSArray *)rangeArr fontArr:(NSArray *)fontArr colorArr:(NSArray *)colorArr;
    
@end
