//
//  BBTucaoViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/3.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBTucaoViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <XLForm.h>

@interface BBTucaoViewController ()
@property (nonatomic) XLFormRowDescriptor *feedbackRow;
@property (nonatomic) AVUserFeedbackAgent *agent;

@end

@implementation BBTucaoViewController

-(instancetype)init{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"用户反馈"];
    XLFormSectionDescriptor * section;
    formDescriptor.assignFirstResponderOnShow = YES;
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"请留下您最宝贵的意见，我将第一时间看到您的反馈！（这个反馈是匿名的。）"];
    _feedbackRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"introduction" rowType:XLFormRowDescriptorTypeTextView];
    [_feedbackRow.cellConfigAtConfigure setObject:@"请多多批评指教，非常感谢！" forKey:@"textView.placeholder"];
    _feedbackRow.required = YES;
    [section addFormRow:_feedbackRow];
    [formDescriptor addFormSection:section];
    
    return [super initWithForm:formDescriptor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _agent = [AVUserFeedbackAgent sharedInstance];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(feedback:)];
    self.navigationItem.rightBarButtonItem = edit;
}

-(IBAction)feedback:(id)sender{
    
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    [_agent postFeedbackThread:_feedbackRow.value block:^(id object, NSError *error) {
        if (!error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"顺利吐槽!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
