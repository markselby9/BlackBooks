//
//  BBForgetPasswordViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/3.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBForgetPasswordViewController.h"
#import <XLForm.h>
#import <AVOSCloud/AVOSCloud.h>

@interface BBForgetPasswordViewController ()

@property (nonatomic) XLFormRowDescriptor* emailRow;

@end

@implementation BBForgetPasswordViewController

-(instancetype)init{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"重置密码"];
    XLFormSectionDescriptor * section;
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"请填写您的邮箱"];
    section.footerTitle = @"我们将发送密码重置邮件到您的邮箱中，请查收";
    
    
    _emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"邮箱"];
    _emailRow.required = YES;
    [section addFormRow: _emailRow];
    [formDescriptor addFormSection:section];
    
    // Button
//    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"button" rowType:XLFormRowDescriptorTypeButton title:@"登录"];
//    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
//    buttonRow.action.formSelector = @selector(login:);
//    [section addFormRow:buttonRow];
    
    return [super initWithForm:formDescriptor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *forget = [[UIBarButtonItem alloc]initWithTitle:@"发送重置邮件" style:UIBarButtonItemStyleDone target:self action:@selector(sendForgetEmail:)];
    self.navigationItem.rightBarButtonItem = forget;
}

-(IBAction)sendForgetEmail:(id)sender{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    [AVUser requestPasswordResetForEmailInBackground:_emailRow.value block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"重置邮件已经发送，请查收您的邮箱。" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
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
