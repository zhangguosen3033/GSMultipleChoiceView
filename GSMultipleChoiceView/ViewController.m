//
//  ViewController.m
//  GSMultipleChoiceView
//
//  Created by ygkj on 2017/6/12.
//  Copyright © 2017年 ygkj. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "RedChipMultipleChoiceView.h"

#define ratio_width ([UIScreen mainScreen].bounds.size.width)/375.0
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<redChipMultipleDelgate>
{
    RedChipMultipleChoiceView * MultipleChoiceView;
    NSMutableArray *menuButtonArray;
    NSMutableArray *menuImageArray;
    UIButton *lastSelectBtn;//用于区分筛选时是不是点击的同一个btn;
    BOOL     menuButtonSelectedFirstBool;
    
    NSString *goodList_sort;
    NSString *goodsList_order;
    NSArray *arrName;//二级筛选的名字
    BOOL     firstOpenSelctBool;
    NSNumber *currentSelctNum;
    NSInteger oldClickTag;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //页面刚进入默认加载的内容
    currentSelctNum= @2;
    goodList_sort = @"1";
    goodsList_order = @"desc";
    menuButtonArray = [[NSMutableArray alloc]init];
    menuImageArray =  [[NSMutableArray alloc]init];
    
    MultipleChoiceView =[[RedChipMultipleChoiceView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45*ratio_width) titles:@[@"待展期", @"未到期", @"已结束",@"全部"] moreSelctBtnTitle:@"筛选" btn_w:SCREEN_WIDTH/5];
    
    
    MultipleChoiceView.delgate =self;
    [self.view addSubview:MultipleChoiceView];
    //给view添加autolayout constraints
    [self.view addSubview:self.SlectbottomView];
    
    firstOpenSelctBool =YES;
    self.SlectbottomView.hidden =YES;
    [self viewMakeMasConstraints];
}
#pragma mark - 头部控制的代理方法
//点击左边滚动的返回 点击的具体的点击按钮
-(void)redChipClicktWith:(NSNumber *)nowSelect{
    
    NSLog(@"-----%ld",[nowSelect integerValue]);
    //    [MultipleChoiceView.moreSelectBtn setTitleColor:[Toolkit getColor:hex_606060] forState:UIControlStateNormal];
    [MultipleChoiceView.moreSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    MultipleChoiceView.selcetBtnIsSelect = NO;
    MultipleChoiceView.rightView.image =[UIImage imageNamed:@"红筹优化新图标三角-下-@2x"];
    self.SlectbottomView.hidden =YES;
    
    currentSelctNum = nowSelect;
    
    //点击一级标题 下面的关闭  设置默认传参
    goodList_sort = @"1";
    goodsList_order = @"desc";
    
    //然后点击  请求网络 刷新tableview
    
}
//点击筛选按钮
-(void)clickMoreSelcetBtn{
    if ([currentSelctNum integerValue] == 4) {
        arrName = @[@"参与时间",@"结束时间",@"奖励"];
    }else{
        arrName = @[@"参与时间",@"到期时间",@"奖励"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self prepareMenuViewSubviews];
        
    });
    
    if (MultipleChoiceView.selcetBtnIsSelect) {
        //        [MultipleChoiceView.moreSelectBtn setTitleColor:[Toolkit getColor:hex_606060] forState:UIControlStateNormal];
        [MultipleChoiceView.moreSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        MultipleChoiceView.selcetBtnIsSelect = NO;
        MultipleChoiceView.rightView.image =[UIImage imageNamed:@"红筹优化新图标三角-下-@2x"];
        self.SlectbottomView.hidden =YES;
    }else{
        //        [MultipleChoiceView.moreSelectBtn setTitleColor:[Toolkit getColor:hex_ff5600] forState:UIControlStateNormal];
        [MultipleChoiceView.moreSelectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        MultipleChoiceView.selcetBtnIsSelect = YES;
        MultipleChoiceView.rightView.image =[UIImage imageNamed:@"红筹优化新图标三角-上@2x"];
        self.SlectbottomView.hidden =NO;
    }
}
-(void)prepareMenuViewSubviews {
    
    [menuButtonArray removeAllObjects];
    [menuImageArray removeAllObjects];
    [self.SlectbottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除父试图上的子试图
    
    CGFloat btn_edge = 20;
    CGFloat btn_width=80*ratio_width;
    CGFloat btn_height=25*ratio_width;
    CGFloat btn_padding_lr=(SCREEN_WIDTH-btn_width*3-btn_edge*2)/2;
    CGFloat btn_padding_ud=20;
    for (int i=0; i<arrName.count; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btn_edge+(btn_width+btn_padding_lr)*i, btn_padding_ud-7, btn_width, btn_height)];
        //        [btn setTitleColor:[Toolkit getColor:hex_606060] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn setTitle:arrName[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseProperties:) forControlEvents:UIControlEventTouchUpInside];
        [self.SlectbottomView addSubview:btn];
        UIImageView *imageView = [UIImageView new];
        if (i==2) {
            imageView.frame = CGRectMake(btn_edge+(btn_width)*(i+1)+i*btn_padding_lr- 12*ratio_width, btn_padding_ud, 5, 10);
        }else{
            imageView.frame = CGRectMake(btn_edge+(btn_width)*(i+1)+i*btn_padding_lr+5*ratio_width , btn_padding_ud, 5, 10);
        }
        //记住标题选中状态
        if ([goodList_sort isEqualToString:@"1"] && [goodsList_order isEqualToString:@"desc"]) {
            
            if (i==0)
            {
                //                [btn setTitleColor:[Toolkit getColor:hex_red_color] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                imageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下-色@2x"];
                menuButtonSelectedFirstBool = YES;
            }else{
                imageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下--灰@2x"];
            }
            oldClickTag = 0;
        }else{
            
            if (i==([goodList_sort integerValue] -1))
            {
                //                [btn setTitleColor:[Toolkit getColor:hex_red_color] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                if ([goodsList_order isEqualToString:@"desc"]) {
                    imageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下-色@2x"];
                }else{
                    imageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-上-色-@2x"];
                }
            }else{
                imageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下--灰@2x"];
            }
            oldClickTag = [goodList_sort integerValue] -1;
        }
        
        [self.SlectbottomView addSubview:imageView];
        [menuImageArray addObject:imageView];
        [menuButtonArray addObject:btn];
    }
}
-(void)chooseProperties:(UIButton *)button{
    
    //首先改变把所有按钮的文字改变为黑色
    for (UIButton *tempBtn in menuButtonArray){
        //        [tempBtn setTitleColor:[Toolkit getColor:hex_606060] forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    //把选中的按钮的颜色改为红色
    //    [button setTitleColor:[Toolkit getColor:hex_red_color] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //筛选升、降图标恢复默认
    for (UIImageView *tempImageView in menuImageArray){
        
        tempImageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下--灰@2x"];
    }
    
    UIImageView *selectedImageView = menuImageArray[button.tag];
    selectedImageView.image =nil;
    
    //为menuButtonSelectedFirstBool变量判断赋值 区分点击的是否同一个按钮
    if (oldClickTag == button.tag) {
        menuButtonSelectedFirstBool = !menuButtonSelectedFirstBool;
    }else{
        menuButtonSelectedFirstBool =YES;
        oldClickTag = button.tag;
    }
    //判断menuButtonSelectedFirstBool
    if (menuButtonSelectedFirstBool) {
        goodsList_order = @"desc";
        NSLog(@"____________DESC  降  高->低");
        
    }else {
        //ASC  升 低->高 ;  DESC  降  高->低
        goodsList_order = @"asc";
        NSLog(@"_____________ASC  升 低->高");
    }
    if ([goodsList_order isEqualToString:@"asc"]) {
        selectedImageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-上-色-@2x"];
    }else if ([goodsList_order isEqualToString:@"desc"]){
        selectedImageView.image = [UIImage imageNamed:@"红筹优化新图标小箭头-下-色@2x"];
    }else {
    }
    
    /**
     *  筛选条件的标识
     *  1   时间
     *  2   展期
     *  3   奖励
     */
    switch (button.tag) {
        case 0: {
            //参与时间
            goodList_sort = @"1";
            break;
        }
        case 1: {
            //展期时间   结束时间
            goodList_sort = @"2";
            break;
        }
        case 2: {
            //奖励
            goodList_sort = @"3";
            break;
        }
        default:
            break;
    }
    
    //做网络请求相关
    //然后点击  请求网络 刷新tableview
    
}
#pragma mark - 懒加载
//二级筛选背景
-(UIView *)SlectbottomView{
    if (!_SlectbottomView) {
        
        _SlectbottomView =[UIView new];
        _SlectbottomView.backgroundColor =[UIColor whiteColor];
        
    }
    
    return _SlectbottomView;
}
#pragma mark - AutoLayout代码布局
/**
 *  给vc中的view添加autolayout constraints
 */
-(void)viewMakeMasConstraints{
    //    [self.segmentControl makeConstraints:^(MASConstraintMaker* make){
    //        make.top.equalTo(self.view).offset(64);
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(44);
    //    }];
    
    //    [self.tableView makeConstraints:^(MASConstraintMaker* make){
    //        make.top.equalTo(self.segmentControl.bottom);
    //        make.bottom.equalTo(self.view);
    //
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //
    //    }];
    
    
    [self.SlectbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MultipleChoiceView.mas_bottom).offset(0.5);
        make.left.equalTo(self.view);
        make.height.equalTo(@(111/2.0*ratio_width));
        make.width.equalTo(self.view);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
