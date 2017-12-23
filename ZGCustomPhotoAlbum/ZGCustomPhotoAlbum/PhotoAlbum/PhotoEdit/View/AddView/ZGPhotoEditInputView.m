//
//  ZGPhotoEditInputView.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditInputView.h"
#import "ZGPhotoEditColorBar.h"
#import "ZGPhotoEditHeader.h"

@interface ZGPhotoEditInputView()<UITextViewDelegate, ZGPhotoEditColorBarDelegate>
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) ZGPhotoEditColorBar *colorBar;


@end
@implementation ZGPhotoEditInputView

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
                [self initNavBarButtons];
                //输入框
                self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44)];
                self.textView.backgroundColor = [UIColor clearColor];
                self.textView.font = [UIFont systemFontOfSize:20];
                self.textView.delegate = self;
                self.textView.keyboardType = UIKeyboardTypeDefault;
                self.textView.textColor = [UIColor whiteColor];
                [self addSubview:self.textView];
                [self addObserver];
                self.colorBar = [[ZGPhotoEditColorBar alloc] init];
                self.colorBar.backgroundColor = [UIColor clearColor];
                self.colorBar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 49);
                self.colorBar.colorDelegate = self;
                [self addSubview:self.colorBar];
        }
        return self;
}
- (void)photoEditColorViewSelectedColor:(UIColor *)color isDraw:(BOOL)draw{
        self.textView.textColor = color;
        self.color  = color;
}
- (void)addObserver{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
}

-(void)keyboardWillShow:(NSNotification *)notification
{
        //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
        CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self.colorBar cellSelected:_color];
        self.textView.frame = CGRectMake(0, HEIGHT_PHOTO_EIDT_BAR_NAV_X, self.frame.size.width, self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_NAV_X - frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
        self.colorBar.frame = CGRectMake(0, frame.origin.y - 49, self.frame.size.width, 49);
}

-(void)keyboardWillHidden:(NSNotification *)notification
{
        self.textView.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44);
        self.colorBar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 49);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [self.textView resignFirstResponder];
}
//记得释放通知

-(void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setColor:(UIColor *)color{
        _color = color;
        self.textView.textColor = color;
}
-(void)setText:(NSString *)text{
        _text = text;
        self.textView.text = text;
}
- (void) initNavBarButtons{
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Close2"] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(10, HEIGHT_PHOTO_EIDT_BAR_NAV_X - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        cancelButton.tag = 0;
        [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        UIButton *finishiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishiButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Save"] forState:UIControlStateNormal];
        finishiButton.frame = CGRectMake(self.frame.size.width - HEIGHT_PHOTO_EIDT_BAR_NAV - 10, HEIGHT_PHOTO_EIDT_BAR_NAV_X - HEIGHT_PHOTO_EIDT_BAR_NAV , HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        finishiButton.tag = 1;
        [finishiButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishiButton];
        
}
-(void)buttonAction:(UIButton *)button{
        [self.textView resignFirstResponder];
        if (button.tag == 0) {
                if (self.inputDelegate && [self.inputDelegate conformsToProtocol:@protocol(ZGPhotoEditInputViewDelegate)]) {
                        [self.inputDelegate inputViewDidCancel:self];
                }
        }else if (button.tag == 1){
                if (self.inputDelegate && [self.inputDelegate conformsToProtocol:@protocol(ZGPhotoEditInputViewDelegate)]) {
                        [self.inputDelegate inputView:self didFinishContent:self.textView.text textColor:self.textView.textColor];
                }
        }
}
@end
