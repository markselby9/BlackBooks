//
//  BBRegisterViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/26.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "XLForm.h"
#import "DXAlertView.h"
#import "XLFormImageSelectorCell.h"

@interface BBRegisterViewController ()

@property(nonatomic) XLFormRowDescriptor *imageRow;
@property(nonatomic) XLFormRowDescriptor *nameRow;
@property(nonatomic) XLFormRowDescriptor *nicknameRow;
@property(nonatomic) XLFormRowDescriptor *emailRow;
@property(nonatomic) XLFormRowDescriptor *passwordRow;
@property(nonatomic) XLFormRowDescriptor *passwordagainRow;
@property(nonatomic) XLFormRowDescriptor *introductionRow;
@end

@implementation BBRegisterViewController

- (id)init {
  XLFormDescriptor *formDescriptor =
      [XLFormDescriptor formDescriptorWithTitle:@"欢迎加入马特里二手书店"];
  XLFormSectionDescriptor *section;
  formDescriptor.assignFirstResponderOnShow = YES;

  // Basic Information - Section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"您"
                                                          @"的基本信息"];
  section.footerTitle = @"用"
                        @"户名注册之后不可修改，您可以使用昵称，但请填写真实有"
                        @"效的联系方式";
  [formDescriptor addFormSection:section];

  // image cell
  _imageRow = [XLFormRowDescriptor
      formRowDescriptorWithTag:@"image"
                       rowType:@"XLFormRowDescriptorTypeCustom"];
  _imageRow.title = @"添加头像";
  //    descriptor.value = nil;
  [_imageRow setCellClass:([XLFormImageSelectorCell class])];
  _imageRow.required = YES;
  [section addFormRow:_imageRow];

  // Name
  _nameRow =
      [XLFormRowDescriptor formRowDescriptorWithTag:@"name"
                                            rowType:XLFormRowDescriptorTypeText
                                              title:@"用户名"];
  _nameRow.required = YES;
  [section addFormRow:_nameRow];

  // Name
  _nicknameRow =
      [XLFormRowDescriptor formRowDescriptorWithTag:@"nickname"
                                            rowType:XLFormRowDescriptorTypeText
                                              title:@"昵称"];
  _nicknameRow.required = YES;
  [section addFormRow:_nicknameRow];

  // Email
  _emailRow =
      [XLFormRowDescriptor formRowDescriptorWithTag:@"email"
                                            rowType:XLFormRowDescriptorTypeEmail
                                              title:@"真实邮箱"];
  // validate the email
  [_emailRow addValidator:[XLFormValidator emailValidator]];
  _emailRow.required = YES;
  [section addFormRow:_emailRow];

  // Password
  _passwordRow = [XLFormRowDescriptor
      formRowDescriptorWithTag:@"password"
                       rowType:XLFormRowDescriptorTypePassword
                         title:@"密码"];
  _passwordRow.required = YES;
  [section addFormRow:_passwordRow];

  // Password
  _passwordagainRow = [XLFormRowDescriptor
      formRowDescriptorWithTag:@"passwordagain"
                       rowType:XLFormRowDescriptorTypePassword
                         title:@"确认密码"];
  _passwordagainRow.required = YES;
  [section addFormRow:_passwordagainRow];

  section = [XLFormSectionDescriptor
      formSectionWithTitle:@"还有啥需要补充的吗"];

  _introductionRow = [XLFormRowDescriptor
      formRowDescriptorWithTag:@"introduction"
                       rowType:XLFormRowDescriptorTypeTextView];
  [_introductionRow.cellConfigAtConfigure
      setObject:@"我是一个读书爱好者，我的微信号码是..."
                @"随便写写吧"
         forKey:@"textView.placeholder"];
  _introductionRow.required = YES;
  [section addFormRow:_introductionRow];
  [formDescriptor addFormSection:section];

  return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  UIBarButtonItem *reg =
      [[UIBarButtonItem alloc] initWithTitle:@"加入书店"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(submit:)];
  self.navigationItem.rightBarButtonItem = reg;

  UIBarButtonItem *cancelReg = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(cancelRegister:)];
  self.navigationItem.leftBarButtonItem = cancelReg;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
  NSArray *validationErrors = [self formValidationErrors];
  if (validationErrors.count > 0) {
    [self showFormValidationError:[validationErrors firstObject]];
    return;
  }
  [self.tableView endEditing:YES];
  if (![_passwordRow.value isEqualToString:(_passwordagainRow.value)]) {
    UIAlertView *errorAlertView =
        [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"两次密码输入不同"
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil];
    [errorAlertView show];
    return;
  }
  AVUser *user = [AVUser user];

  user.username = _nameRow.value;

  // avatar image 头像
  NSData *imagefiledata = UIImageJPEGRepresentation(_imageRow.value, 1.0);
  AVFile *imageFile = [AVFile
      fileWithName:[NSString stringWithFormat:@"%@-image", user.username]
              data:imagefiledata];
  [user setObject:imageFile forKey:@"image"];

  [user setObject:_nicknameRow.value forKey:@"nickname"];
  user.password = _passwordRow.value;
  user.email = _emailRow.value;
  [user setObject:_introductionRow.value forKey:@"introduction"];

  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      UIAlertView *alertView =
          [[UIAlertView alloc] initWithTitle:@"OK"
                                     message:@"欢迎您的加入！"
                                    delegate:nil
                           cancelButtonTitle:@"Ok"
                           otherButtonTitles:nil, nil];
      [alertView show];
      [self.presentingViewController dismissViewControllerAnimated:YES
                                                        completion:nil];
    } else {
      // Something bad has ocurred
      NSString *errorString = [[error userInfo] objectForKey:@"error"];
      UIAlertView *errorAlertView =
          [[UIAlertView alloc] initWithTitle:@"Error"
                                     message:errorString
                                    delegate:nil
                           cancelButtonTitle:@"Ok"
                           otherButtonTitles:nil, nil];
      [errorAlertView show];
    }
  }];
}

- (IBAction)cancelRegister:(id)sender {
  [self.view endEditing:YES];
  DXAlertView *alertview = [[DXAlertView alloc]
         initWithTitle:@"确认取消吗？"
           contentText:@"这一页填写的内容将不会保存"
       leftButtonTitle:@"OK"
      rightButtonTitle:@"Cancel"];
  alertview.leftBlock = ^() {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
  };
  alertview.rightBlock = ^() {

  };
  [alertview show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
