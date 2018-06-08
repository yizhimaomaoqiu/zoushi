//
//  NumTab_cell.m
//  ZouShi
//
//  Created by admin on 18/1/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NumTab_cell.h"

@interface NumTab_cell ()

@property (nonatomic, strong)NSMutableArray *labArr;

@end

@implementation NumTab_cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}


- (void)creatUI{
    _labArr = [NSMutableArray array];
    CGFloat w = [UIScreen mainScreen].bounds.size.width / 11;
    for (NSInteger i = 0; i < 11; i ++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i * w, 0, w, 50)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:lab];
        [_labArr addObject:lab];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:view];
}

- (void)setTextArr:(NSArray *)arr{
    
    for (NSInteger i = 1; i <= 11; i ++) {
        UILabel *lab = self.labArr[i - 1];
        if ([arr containsObject:[NSString stringWithFormat:@"%zd", i]]) {
            lab.text = [NSString stringWithFormat:@"%zd", i];
            lab.backgroundColor = [UIColor colorWithRed:18.f/255.f green:150.f/255.f blue:219.f/255.f alpha:0.5];
        }else{
            lab.text = @"";
            lab.backgroundColor = [UIColor whiteColor];
        }
    }
    
//    for (NSInteger i = 0; i < arr.count; i ++) {
//        UILabel *lab = self.labArr[i];
//        NSString *str = arr[i];
//        lab.text = str;
//        
//        if ([str isEqualToString:@""]) {
//            lab.backgroundColor = [UIColor whiteColor];
//        }else{
//            lab.backgroundColor = [UIColor colorWithRed:18.f/255.f green:150.f/255.f blue:219.f/255.f alpha:0.5];
//        }
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
