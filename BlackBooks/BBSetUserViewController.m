//
//  BBSetUserViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/3.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBSetUserViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <XLForm.h>
#import "XLFormImageSelectorCell.h"

@interface BBSetUserViewController ()
@property (nonatomic) XLFormRowDescriptor* imageRow;
@property (nonatomic) XLFormRowDescriptor* nameRow;
@property (nonatomic) XLFormRowDescriptor* nicknameRow;
@property (nonatomic) XLFormRowDescriptor* emailRow;
@property (nonatomic) XLFormRowDescriptor* passwordRow;
@property (nonatomic) XLFormRowDescriptor* passwordagainRow;
@property (nonatomic) XLFormRowDescriptor* introductionRow;
@end

@implementation BBSetUserViewController

-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"个人资料修改"];
    XLFormSectionDescriptor * section;
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"密码如果不修改请留空"];
    section.footerTitle = @"可以使用昵称，但请填写真实的联系方式方便对书感兴趣的人联系您";
    [formDescriptor addFormSection:section];
    
    
    //image cell
    _imageRow= [XLFormRowDescriptor formRowDescriptorWithTag:@"image" rowType:@"XLFormRowDescriptorTypeCustom"];
    _imageRow.title = @"设置头像";
    //    descriptor.value = nil;
    [_imageRow setCellClass:([XLFormImageSelectorCell class])];
    _imageRow.required = YES;
    [section addFormRow:_imageRow];
    
    // Name
    _nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    _nameRow.disabled = YES;
    [section addFormRow:_nameRow];
    
    // Name
    _nicknameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"nickname" rowType:XLFormRowDescriptorTypeText title:@"昵称"];
    _nicknameRow.required = YES;
    [section addFormRow:_nicknameRow];
    
    // Email
    _emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail title:@"真实邮箱"];
    // validate the email
    [_emailRow addValidator:[XLFormValidator emailValidator]];
    _emailRow.required = YES;
    _emailRow.disabled = YES;
    [section addFormRow:_emailRow];
    
    AVUser *user = [AVUser currentUser];
    NSString *emailVerified = [NSString stringWithFormat:@"%@", [user objectForKey:@"emailVerified"]];
    if ([emailVerified isEqualToString:@"0"]){
        XLFormRowDescriptor* row = [XLFormRowDescriptor formRowDescriptorWithTag:@"emailverified" rowType:XLFormRowDescriptorTypeText title:nil];
        [row setValue:@"您的邮箱未验证，请检查邮件"];
        row.disabled = YES;
        [section addFormRow:row];
    }
    
//    // Password
//    _passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"密码"];
//    _passwordRow.required = YES;
//    [section addFormRow:_passwordRow];
//    
//    // Password
//    _passwordagainRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"passwordagain" rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
//    _passwordagainRow.required = YES;
//    [section addFormRow:_passwordagainRow];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"补充一些关于您的信息"];
    _introductionRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"introduction" rowType:XLFormRowDescriptorTypeTextView];
    [_introductionRow.cellConfigAtConfigure setObject:@"我是一个读书爱好者，我的微信号码是...随便写写吧" forKey:@"textView.placeholder"];
    _introductionRow.required = YES;
    [section addFormRow:_introductionRow];
    [formDescriptor addFormSection:section];
    
    return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStyleDone target:self action:@selector(editUser:)];
    self.navigationItem.rightBarButtonItem = edit;
    
    //头像
    AVFile *userimagefile = [self.user objectForKey:@"image"];
    NSData *userimagedata = [userimagefile getData];
    UIImage *image = [UIImage imageWithData:userimagedata];
    [_imageRow setValue:image];
    
    [_nameRow setValue:self.user.username];
    [_nicknameRow setValue:[self.user valueForKey:@"nickname"]];
    [_emailRow setValue:self.user.email];
    [_introductionRow setValue:[self.user valueForKey:@"introduction"]];
}

-(IBAction)editUser:(id)sender{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    AVUser *user = [AVUser currentUser];
//    if ([_passwordRow.value length]!=0){
//        if (![_passwordRow.value isEqualToString:(_passwordagainRow.value)]){
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"两次密码输入不同" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [errorAlertView show];
//            return;
//        }else{
//            user.password = _passwordRow.value;
//        }
//    }
    
//    user.username = _nameRow.value;
//    user.email = _emailRow.value;
    
    
    NSData *imagefiledata = UIImageJPEGRepresentation(_imageRow.value, 1.0);
    AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@-image",  user.username] data:imagefiledata];
    [user setObject:imageFile forKey:@"image"];
    
    [user setObject:_nicknameRow.value forKey:@"nickname"];
    [user setObject:_introductionRow.value forKey:@"introduction"];
    [user save];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"资料修改成功!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    [user refresh];
    [self.navigationController popViewControllerAnimated:YES];
    
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"资料修改成功!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alertView show];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [AVUser logInWithUsername:user.username password:user.password error:nil];
//            }];
//        } else {
//            //Something bad has ocurred
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [errorAlertView show];
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
