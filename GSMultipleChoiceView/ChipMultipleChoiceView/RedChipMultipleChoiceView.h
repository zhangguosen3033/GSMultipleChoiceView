//
//  RedChipMultipleChoiceView.h
//  mall3658
//
//  Created by ygkj on 2017/5/18.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol redChipMultipleDelgate <NSObject>

-(void)redChipClicktWith:(NSNumber *)nowSelect;

-(void)clickMoreSelcetBtn;
@end

@interface RedChipMultipleChoiceView : UIView

@property(nonatomic,assign)BOOL selcetBtnIsSelect;

@property(nonatomic,strong)UIView *lineView;

/**
 *  最后一个条件筛选的按钮
 */
@property(nonatomic,strong)UIButton *moreSelectBtn;
@property(nonatomic,strong)UIView* rightBaseView;
@property(nonatomic,strong)UIImageView* rightView;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 传入数组
 *  @moreSelctBtnTitle  传入条件筛选按钮的标题
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray moreSelctBtnTitle:(NSString *)moreSelctBtnTitleStr btn_w:(CGFloat)btn_w ;

//选中的头部滚动按钮的方法
@property(nonatomic,weak)id<redChipMultipleDelgate>delgate;
@end
