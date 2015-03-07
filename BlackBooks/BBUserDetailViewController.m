//
//  BBUserDetailViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBUserDetailViewController.h"
#import "BBUserManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import <M80AttributedLabel.h>

@interface BBUserDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *userDetailView;
@property (nonatomic) AVUser *user;

@end

@implementation BBUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BBUserManager findUserByName:self.username];
    
    // Do any additional setup after loading the view from its nib.
    
    //    self.detailView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.userDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addUserDetailView:self.user];
    self.title = [NSString stringWithFormat:@"%@ 的资料", self.user.username];
    
}

-(void)addUserDetailView:(AVUser*)user{
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    label.lineSpacing = 5.0;
//    [label appendImage:[UIImage imageNamed:@"user"
//                        ] maxSize:CGSizeMake(50, 50)
//                margin:UIEdgeInsetsZero
//             alignment:M80ImageAlignmentCenter];
    
    NSString *text  = [self textForView];
    [label appendText:text];
    
    label.frame = CGRectInset(self.userDetailView.bounds,20,20);
    [label setTextAlignment:kCTTextAlignmentNatural];
    
    [self.userDetailView addSubview:label];
}

- (NSString *)textForView
{
    NSString *text = [[NSString alloc]init];
    if (!self.user){
        return @"no result!";
    }
    text = [text stringByAppendingString:([NSString stringWithFormat:@"用户名： %@\r", self.user.username])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"昵称： %@\r", [self.user valueForKey:@"nickname"]])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"邮箱： %@\r", self.user.email])];
    if (self.user.mobilePhoneNumber){
        text = [text stringByAppendingString:([NSString stringWithFormat:@"手机号码： %@\r", self.user.mobilePhoneNumber])];
    }
    NSLog(@"found user: %@", self.user);
    NSLog(@"%@", text);
    return text;
    //    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ftcoretext-example-text-giraffe" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)beginChat:(id)sender {
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
