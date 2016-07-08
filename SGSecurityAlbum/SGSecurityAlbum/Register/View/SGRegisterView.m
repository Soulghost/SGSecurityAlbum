//
//  SGRegisterView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGRegisterView.h"

#define PasswordFieldTag -1
#define ConfirmFieldTag  -2

@interface SGRegisterView () <UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic, weak) UILabel *logoLabel;
@property (nonatomic, weak) UITextField *pwdFiled;
@property (nonatomic, weak) UITextField *confirmField;
@property (nonatomic, copy) SGRegisterBlock registerHandler;

@end

@implementation SGRegisterView

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
    logoLabel.text = @"Add Account";
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
    pwdFiled.tag = PasswordFieldTag;
    pwdFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdFiled.delegate = self;
    pwdFiled.returnKeyType = UIReturnKeyNext;
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
    UITextField *confirmField = [UITextField new];
    confirmField.tag = ConfirmFieldTag;
    confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmField.delegate = self;
    confirmField.returnKeyType = UIReturnKeyGo;
    confirmField.textAlignment = NSTextAlignmentCenter;
    confirmField.secureTextEntry = YES;
    confirmField.placeholder = @"Please confirm your password";
    confirmField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmField = confirmField;
    [self addSubview:confirmField];
    [confirmField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdFiled.mas_bottom).offset(10);
        make.left.equalTo(superview).offset(20);
        make.right.equalTo(superview).offset(-20);
        make.height.equalTo(28);
    }];
}

- (void)setHandler:(SGRegisterBlock)handler {
    self.registerHandler = handler;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.pwdFiled becomeFirstResponder];
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == PasswordFieldTag) {
        [self.confirmField becomeFirstResponder];
    } else {
        if (self.registerHandler) {
            self.registerHandler(self.pwdFiled.text, self.confirmField.text);
        }
    }
    return YES;
}

@end
