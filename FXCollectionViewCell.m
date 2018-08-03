//
//  FXCollectionViewCell.m
//  UICollectionViewCellMove
//
//  Created by fengxin on 2018/8/3.
//  Copyright © 2018年 fengxin. All rights reserved.
//

#import "FXCollectionViewCell.h"
//屏幕宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
@implementation FXCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.markLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 10,  ScreenWidth/4 - 30,  45)];
        self.markLabel.font = [UIFont systemFontOfSize:14];
        self.markLabel.textAlignment = NSTextAlignmentLeft;
        self.markLabel.userInteractionEnabled = NO;
        self.markLabel.layer.masksToBounds = YES;
        self.markLabel.textColor = [UIColor whiteColor];
        self.markLabel.layer.cornerRadius = 5;
        self.markLabel.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.markLabel];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(-6, -5, 30, 30)];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete_label"] forState:UIControlStateNormal];
         self.deleteButton.hidden = YES;
        [self addSubview:self.deleteButton];
        
    }
    return self;
}

@end
