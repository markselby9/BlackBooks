//
//  BBChangePasswordViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/3.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBChangePasswordViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <XLForm.h>

@interface BBChangePasswordViewController ()

@property (nonatomic) XLFormRowDescriptor* originalpasswordRow;
@property (nonatomic) XLFormRowDescriptor* passwordRow;
@property (nonatomic) XLFormRowDescriptor* passwordagainRow;

@end

@implementation BBChangePasswordViewController

-(instancetype)init{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"密码修改"];
    XLFormSectionDescriptor * section;
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"为了您的账户安全，请先输入原密码"];
    section.footerTitle = @"";
    
    _originalpasswordRow =[XLFormRowDescriptor formRowDescriptorWithTag:@"originalpassword" rowType:XLFormRowDescriptorTypePassword title:@"原密码"];
    _originalpasswordRow.required = YES;
    [section addFormRow:_originalpasswordRow];

    
    // Password
    _passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"新密码"];
    _passwordRow.required = YES;
    [section addFormRow:_passwordRow];
    
    // Password
    _passwordagainRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"passwordagain" rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
    _passwordagainRow.required = YES;
    [section addFormRow:_passwordagainRow];
    [formDescriptor addFormSection:section];
    
    return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *editpass = [[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStyleDone target:self action:@selector(editpassword:)];
    self.navigationItem.rightBarButtonItem = editpass;
}

-(IBAction)editpassword:(id)sender{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    if (![_passwordRow.value isEqualToString:(_passwordagainRow.value)]){
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"两次密码输入不同" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
        return;
    }

//    AVUser *user = [AVUser currentUser];
//    [AVUser logInWithUsername:user.username password:_originalpasswordRow.value]; //请确保用户当前的有效登录状态
    
    [[AVUser currentUser] updatePassword:_originalpasswordRow.value newPassword:_passwordRow.value block:^(id object, NSError *error) {
        if (!error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"密码修改成功！" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
