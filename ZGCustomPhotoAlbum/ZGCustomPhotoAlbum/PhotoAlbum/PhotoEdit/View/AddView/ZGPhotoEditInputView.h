//
//  ZGPhotoEditInputView.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditInputViewDelegate;
@interface ZGPhotoEditInputView : UIView
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIColor *color;


@property(nonatomic, assign) id<ZGPhotoEditInputViewDelegate>  inputDelegate;

@end
@protocol ZGPhotoEditInputViewDelegate <NSObject>
-(void)inputView:(ZGPhotoEditInputView *)inputView didFinishContent:(NSString *)content textColor:(UIColor *)color;
-(void)inputViewDidCancel:(ZGPhotoEditInputView *)inputView;
@end
