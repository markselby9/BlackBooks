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
@interface BBUserDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *userDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *imageOutlet;
@property (weak, nonatomic) IBOutlet UILabel *textLabelOutlet;
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
    NSString *text  = [self textForView];
    [self.textLabelOutlet setText:text];
    
    //load image asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVFile *imagedatafile = [self.user valueForKey:@"image"];
        NSData *imagedata = [imagedatafile getData];
        UIImage *image = [UIImage imageWithData:imagedata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageOutlet setImage:image];
        });
    });
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
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"还没做呢。。" message:@"这里打算做个功能，还没开工。。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertview show];
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
