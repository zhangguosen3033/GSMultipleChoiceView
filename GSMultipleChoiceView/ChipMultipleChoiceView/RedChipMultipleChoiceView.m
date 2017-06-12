//
//  RedChipMultipleChoiceView.m
//  mall3658
//
//  Created by ygkj on 2017/5/18.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RedChipMultipleChoiceView.h"
#import "Masonry.h"
#import "redChipListSegmentView.h"

#define ratio_width ([UIScreen mainScreen].bounds.size.width)/375.0

@implementation RedChipMultipleChoiceView
{
    redChipListSegmentView *listView;
    
    NSNumber *currentStart;//当前的选择模块
    
    CGFloat btnWitd;
    
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray moreSelctBtnTitle:(NSString *)moreSelctBtnTitleStr btn_w:(CGFloat)btn_w {
    
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始筛选按钮不选中
        self.selcetBtnIsSelect =NO;
        //创建头部的滚动试图
        listView=[[redChipListSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width -btn_w, self.frame.size.height) titles:titleArray btn_w:btn_w clickBlick:^void(NSInteger index) {
            
            //全部的时候参数传 1  1/2/3/4   1全部,2待展期,3未到期,4已结束
            if (index == 4) {
                currentStart = @1;
                
            }else{
                currentStart = [NSNumber numberWithInteger:(index +1)] ;  //当前选中状态
                
            }
            [self  loadRequestWith:currentStart];
            
        }];
        //以下属性可以根据需求修改
        //        listView.titleSelectColor=[Toolkit getColor:hex_ff5600];
        listView.titleSelectColor=[UIColor redColor];
        
        
        [self.moreSelectBtn setTitle:moreSelctBtnTitleStr forState:UIControlStateNormal];
        //        [self.moreSelectBtn setTitleColor:[Toolkit getColor:hex_606060] forState:UIControlStateNormal];
        [self.moreSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btnWitd = btn_w;
        
        [self addSubview:listView];
        [self addSubview:self.moreSelectBtn];
        [self addSubview:self.rightBaseView];
        [self.rightBaseView addSubview:self.rightView];
        
        [self addSubview:self.lineView];
        
        [self viewMakeMasConstraints];
        
    }
    
    return  self;
}

#pragma mark -点击之后的方法
//选中之后执行的方法
-(void)loadRequestWith:(NSNumber *)currentSelect{
    if (self.delgate) {
        
        [self.delgate redChipClicktWith:currentSelect];
    }
    
}
-(void)moreSelectBtnClick{
    
    if (self.delgate) {
        
        [self.delgate clickMoreSelcetBtn];
    }
    
}

#pragma mark - 懒加载
-(UIButton *)moreSelectBtn{
    
    if (!_moreSelectBtn) {
        
        _moreSelectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_moreSelectBtn setBackgroundColor:[UIColor whiteColor]];
        _moreSelectBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [_moreSelectBtn addTarget:self action:@selector(moreSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreSelectBtn;
}
-(UIView *)rightBaseView{
    if (!_rightBaseView) {
        
        _rightBaseView =[UIView new];
        //        _rightBaseView.backgroundColor =[UIColor redColor];
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSelectBtnClick)];
        
        _rightBaseView.userInteractionEnabled=YES;
        [_rightBaseView addGestureRecognizer:tapRecognizer];
    }
    return _rightBaseView;
}

-(UIImageView *)rightView{
    if (!_rightView) {
        
        _rightView =[UIImageView new];
        _rightView.image =[UIImage imageNamed:@"红筹优化新图标三角-下-@2x"];
    }
    return _rightView;
}


-(UIView *)lineView{
    if (!_lineView) {
        
        _lineView =[UIView new];
        //        _lineView.backgroundColor =[Toolkit getColor:hex_aaaaaa];
        _lineView.backgroundColor =[UIColor grayColor];
        
    }
    
    return _lineView;
}

#pragma mark - 界面的布局
-(void)viewMakeMasConstraints{
    
    [self.moreSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(@(-15*ratio_width));
        make.height.equalTo(@(45*ratio_width));
        make.width.equalTo(@(btnWitd -15*ratio_width));
    }];
    [self.rightBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.moreSelectBtn.mas_right).offset(-8*ratio_width);
        make.right.equalTo(self);
        make.height.equalTo(@(45*ratio_width));
        
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20*ratio_width));
        make.left.equalTo(self.moreSelectBtn.mas_right).offset(-8*ratio_width);
        make.height.equalTo(@(6*ratio_width));
        make.width.equalTo(@(10*ratio_width));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.height.equalTo(@0.5);
        make.width.equalTo(self);
    }];
    
    
}
@end
