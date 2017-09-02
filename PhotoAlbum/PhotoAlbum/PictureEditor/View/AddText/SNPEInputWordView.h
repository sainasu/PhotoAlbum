//
//  SNPEInputWordView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNPEInputWordView;
/**
 *  主要实现输入文本控件, textView是输入框, 弹出键盘;
        确认按钮和取消按钮;
 */

@protocol SNEditTextDelegate <NSObject>
-(void)inputWordView:(SNPEInputWordView *)inputWordView didFinishContent:(NSString *)content textColor:(UIColor *)color;
-(void)customImagePickerControllerDidCancel:(SNPEInputWordView *)inputWordView;



@end
@interface SNPEInputWordView : UIView
{
        UIButton *_selectedButton;
}

@property(nonatomic, assign) id<SNEditTextDelegate> delegate;
/**
 *输入板
 */
@property(nonatomic, strong) UITextView *textView;
/**
 *工具栏
 */
@property(nonatomic, strong) UIView *toolsView;

/**
 *颜色
 */
@property(nonatomic, strong) UIColor *currColor;

@property(nonatomic, strong) UIView  *currColorView;




@end
