//
//  BBLoginViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBLoginViewController.h"
#import <XLForm.h>
#import <AVOSCloud/AVOSCloud.h>
#import "DXAlertView.h"
#import "BBForgetPasswordViewController.h"
#import "BBRegisterViewController.h"

@interface BBLoginViewController ()

@property (nonatomic) XLFormRowDescriptor* nameRow;
@property (nonatomic) XLFormRowDescriptor* passwordRow;

@end

@implementation BBLoginViewController

-(instancetype)init{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"登录您的账户"];
    XLFormSectionDescriptor * section;
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"欢迎回来"];
//    section.footerTitle = @"忘记密码了？";
    [formDescriptor addFormSection:section];
    
    // Name
    _nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    _nameRow.required = YES;
    [section addFormRow:_nameRow];
    
    // Password
    _passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    _passwordRow.required = YES;
    [section addFormRow:_passwordRow];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [formDescriptor addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"button" rowType:XLFormRowDescriptorTypeButton title:@"登录"];
    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    buttonRow.action.formSelector = @selector(login:);
    [section addFormRow:buttonRow];
    
    XLFormRowDescriptor * buttonRow2 = [XLFormRowDescriptor formRowDescriptorWithTag:@"button" rowType:XLFormRowDescriptorTypeButton title:@"还没有帐号？"];
    [buttonRow2.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    buttonRow2.action.formSelector = @selector(regist2:);
    [section addFormRow:buttonRow2];
    
    return [super initWithForm:formDescriptor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin:)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem *forget = [[UIBarButtonItem alloc]initWithTitle:@"忘记密码了?" style:UIBarButtonItemStyleDone target:self action:@selector(fotgotPassword:)];
    self.navigationItem.rightBarButtonItem = forget;
}

-(IBAction)cancelLogin:(id)sender{
    [self.view endEditing:YES];
    DXAlertView *alertview = [[DXAlertView alloc]initWithTitle:@"确认取消吗？" contentText:@"这一页填写的内容将不会保存" leftButtonTitle:@"OK" rightButtonTitle:@"Cancel"];
    alertview.leftBlock = ^(){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };
    alertview.rightBlock = ^(){
        
    };
    [alertview show];
}

-(IBAction)fotgotPassword:(id)sender{
    BBForgetPasswordViewController *forgetVC= [[BBForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

-(IBAction)regist2:(id)sender{
    BBRegisterViewController *registerVC = [[BBRegisterViewController alloc]init];
//    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    //    [self.navigationController pushViewController:registerVC animated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController setViewControllers:[NSArray arrayWithObject:naviVC] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    NSString *username = self.nameRow.value;
    NSString *password = self.passwordRow.value;
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (!error) {
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"欢迎回来！" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Login failed" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertview show];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
