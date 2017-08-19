//
//  SNPEInputWordView.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "SNPEInputWordView.h"
#import "SNPEViewModel.h"

//颜色选择条底色
#define kPEMyColorToolsColor [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1.0]


@implementation SNPEInputWordView


-(instancetype)initWithFrame:(CGRect)frame{
        self = [super initWithFrame:frame];
        if (self) {
                self.userInteractionEnabled = YES;
                self.backgroundColor = [UIColor blackColor];
                //添加控件
                [self iniUserInterface];
                //文本输入工具栏
                [self createLableTools];
                //创建颜色板
                [self createColorBord];
        }
        return self;
}

//添加控件
-(void)iniUserInterface{
        
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 45, 45);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setImage:[UIImage imageNamed:@"PE_return"] forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        //确认按钮
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(self.frame.size.width - 45, 0, 45, 45);
        [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitAct) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setImage:[UIImage imageNamed:@"PE_navbar_ok"] forState:UIControlStateNormal];
        [self addSubview:submitBtn];
        
        //分割线
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, 1)];
        labe.backgroundColor = [UIColor brownColor];
        [self addSubview:labe];
        //输入框
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 45 , self.frame.size.width, self.frame.size.height / 2 + 50)];
        self.textView.textColor = _currColor;
        [self.textView becomeFirstResponder];
        self.textView.font = [UIFont systemFontOfSize:20];
        
        [self addSubview:self.textView];
}


- (void)cancelAct{
        
        [self removeFromSuperview];
        [self animateNav];
        [self.delegate removeSubView:@"remove"];
        
}

- (void)submitAct{
        [self.delegate addTextWichText:self.textView.text color:self.currColor];
        
        [self removeFromSuperview];
        [self.delegate removeSubView:@"remove"];

        //导航栏隐藏
        [self animateNav];
}

-(void)animateNav{
        [UIView animateWithDuration:0.1 animations:^{
                [[[UINavigationController alloc]init] setNavigationBarHidden:NO animated:YES];
                
        }];
        
}

#pragma mark - 创建文本输入的工具栏
-(void)createLableTools{
        //监听键盘改变或出现时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //监听键盘退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
       

        self.toolsView = [[UIView alloc] initWithFrame:CGRectMake(-self.bounds.size.width,  self.bounds.size.height, self.bounds.size.width, 50)];
        self.toolsView.backgroundColor = kPEMyColorToolsColor;
        //箭头
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PE_MoreColor@2x_09"]];
        imageView.frame = CGRectMake(0, 0, 12.5, 12.5);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(self.frame.size.width - 12.5, self.toolsView.frame.size.height / 2);
        [_toolsView addSubview:imageView];
        [self addSubview:self.toolsView];
        
}
#pragma mark - 键盘出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
        //键盘弹出时显示工具栏
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        float keyBoardHeight = keyboardRect.size.height;
        
        [UIView animateWithDuration:0.1 animations:^{
                self.toolsView.frame = CGRectMake(0, self.frame.size.height-keyBoardHeight - 50, [UIScreen mainScreen].bounds.size.width, 50);
        }];
        
}

#pragma mark 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
        //键盘消失时 隐藏工具栏
        [UIView animateWithDuration:0.1 animations:^{
                self.toolsView.frame = CGRectMake(-self.bounds.size.width,  self.bounds.size.height, self.bounds.size.width, 50);
        }];
}
#pragma mark - 创建色板
-(void)createColorBord{

        UIScrollView *scrollView = [SNPEViewModel initWithColorScrollViewBackgroundColor:kPEMyColorToolsColor frame:CGRectMake(0 , 0, self.bounds.size.width - 25, 50) frameWidth: 50 addTarget:self action:@selector(changeColor:)];
        
        [self.toolsView addSubview:scrollView];
        
}
//切换颜色
-(void)changeColor:(id)target{
        if (target != _selectedButton){
                _selectedButton.selected = NO;
                _selectedButton = target;
        }
        _selectedButton.selected = YES;

        self.currColor = [_selectedButton backgroundColor];
        self.textView.textColor = [_selectedButton backgroundColor];
        self.currColorView.backgroundColor = [_selectedButton backgroundColor];
}


@end
