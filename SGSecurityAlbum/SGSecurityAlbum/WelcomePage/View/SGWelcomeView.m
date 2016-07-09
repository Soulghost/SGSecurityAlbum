//
//  SGWelcomeView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGWelcomeView.h"

@interface SGWelcomeView () <UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic, weak) UILabel *logoLabel;
@property (nonatomic, weak) UITextField *pwdFiled;
@property (nonatomic, copy) SGWelcomeBlock handler;

@end

@implementation SGWelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    self.logoView = logoView;
    [self addSubview:logoView];
    UIView *superview = self;
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(120);
        make.height.equalTo(120);
        make.top.equalTo(superview.mas_top).offset(100);
        make.centerX.equalTo(superview);
    }];
    UILabel *logoLabel = [UILabel new];
    logoLabel.text = @"Agony";
    logoLabel.textColor = [UIColor brownColor];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:32];
    logoLabel.textColor = [UIColor brownColor];
    self.logoLabel = logoLabel;
    [self addSubview:logoLabel];
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
    }];
    UITextField *pwdFiled = [UITextField new];
    pwdFiled.delegate = self;
    pwdFiled.returnKeyType = UIReturnKeyGo;
    pwdFiled.textAlignment = NSTextAlignmentCenter;
    pwdFiled.secureTextEntry = YES;
    pwdFiled.placeholder = @"Please enter your password";
    pwdFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.pwdFiled = pwdFiled;
    [self addSubview:pwdFiled];
    [pwdFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoLabel.mas_bottom).offset(20);
        make.left.equalTo(superview).offset(20);
        make.right.equalTo(superview).offset(-20);
        make.height.equalTo(28);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setWelcomeHandler:(SGWelcomeBlock)handler {
    self.handler = handler;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pwdFiled becomeFirstResponder]; 
    });
}

#pragma mark Notification Callback
- (void)keyboardShow:(NSNotification *)nof {
    CGRect endFrame = [nof.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat endY = endFrame.origin.y;
    CGFloat deltaY = endY - CGRectGetMaxY(self.pwdFiled.frame) - 10;
    if (deltaY < 0 && CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, deltaY);
    }
}

- (void)keyboardHide:(NSNotification *)nof {
    self.transform = CGAffineTransformIdentity;
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.handler) {
        SGAccount *account = [[SGAccountManager sharedManager] getAccountByPwd:textField.text];
        self.handler(account);
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
