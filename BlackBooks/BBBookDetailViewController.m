//
//  BBBookDetailViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBBookDetailViewController.h"
#import "BBUserDetailViewController.h"
//#import "IBActionSheet.h"
#import "UMSocial.h"
#import "BBEditBookViewController.h"
#import <M80AttributedLabel.h>
#import "BBUserStatus.h"
#import "BBLoginViewController.h"
#import "BBUserStatus.h"
#import "DXAlertView.h"

@interface BBBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toobarItem;

@end

@implementation BBBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![BBUserStatus isUserLoggedIn]){
        self.toobarItem.action = @selector(needLogin:);
        self.toobarItem.title = @"登录看更多";
    }
    else if ([self.book.bookOwnerName isEqualToString:([[AVUser currentUser] username])]){
        self.toobarItem.action = @selector(editBook:);
        self.toobarItem.title = @"修改一下信息";
    }
    //need logon
    
//    self.detailView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addBookView:self.book];
    self.title = self.book.bookname;
    
    UIBarButtonItem *shareitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBook:)];
    self.navigationItem.rightBarButtonItem = shareitem;
}

-(void)viewWillAppear:(BOOL)animated{
    if (![BBUserStatus isUserLoggedIn]){
        self.toobarItem.action = @selector(needLogin:);
        self.toobarItem.title = @"登录看更多";
    }
    else if ([self.book.bookOwnerName isEqualToString:([[AVUser currentUser] username])]){
        self.toobarItem.action = @selector(editBook:);
        self.toobarItem.title = @"修改一下信息";
    }
    else{
        self.toobarItem.action = @selector(takeBook:);
        self.toobarItem.title = @"我对这本书感兴趣";
    }
}

-(void)addBookView:(BBBook*)book{
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    label.lineSpacing = 5.0;
//    [label appendImage:[UIImage imageNamed:@"user"
//                        ] maxSize:CGSizeMake(50, 50)
//                margin:UIEdgeInsetsZero
//             alignment:M80ImageAlignmentCenter];
    
    NSString *text  = [self textForView];
    [label appendText:text];
    label.frame = CGRectInset(self.detailView.bounds,20,20);
    [label setTextAlignment:kCTTextAlignmentNatural];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVFile *file = self.book.photo;
        NSLog(@"%@ loaded", file);
        UIImage *image = [UIImage imageNamed:@"book"];
        if (file) {
            NSData *imagedata = [file getData];
            image = [UIImage imageWithData:imagedata];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [label appendImage:image maxSize:CGSizeMake(100, 100)
                        margin:UIEdgeInsetsZero
                     alignment:M80ImageAlignmentCenter];
        });
    });
    
    [self.detailView addSubview:label];
}

- (NSString *)textForView
{
    NSString *text = [[NSString alloc]init];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"\r书名： %@\r", self.book.bookname])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"作者： %@\r", self.book.author])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"原价： %d\r", self.book.originalprice])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"状况： %@\r", self.book.situation])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"主人和这本书的故事： %@\r", self.book.story])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"主人留下的联系方式： %@\r", self.book.contact])];
    text = [text stringByAppendingString:([NSString stringWithFormat:@"希望的现价： %d\r", self.book.price])];

    return text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)needLogin:(id)sender{
    BBLoginViewController *loginVC = [[BBLoginViewController alloc]init];
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

- (IBAction)takeBook:(id)sender {
    UIActionSheet *contactUserSheet = [[UIActionSheet alloc]initWithTitle:@"联系书的主人" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看联系方式", nil];
    [contactUserSheet showInView:self.view];
}

-(IBAction)editBook:(id)sender{
    UIActionSheet *editSheet = [[UIActionSheet alloc]initWithTitle:@"编辑信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除这本书" otherButtonTitles:@"编辑书本信息", nil];
    [editSheet showInView:self.view];
}

//http://dev.umeng.com/social/ios/detail-share#1_3
-(IBAction)shareBook:(id)sender {
//    IBActionSheet *shareAs = [[IBActionSheet alloc] initWithTitle:@"分享这本书给..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"微信",@"QQ"]];
    //    [shareAs showInView:self.view];
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    NSString *shareText = [NSString stringWithFormat:@"来布莱克书店看看这本书：『%@』吧！请搜索app store，『布莱克书店』。（开发者偷懒，暂时没申请各个平台的第三方帐号。。）", self.book.bookname];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f44c92fd98c5c66b00017e"
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,nil]
                                       delegate:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"Button at index: %ld clicked\nIts title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"查看联系方式"]){
        BBUserDetailViewController *userVC = [[BBUserDetailViewController alloc]init];
        userVC.username = self.book.bookOwnerName;
        [self.navigationController pushViewController:userVC animated:YES];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"编辑书本信息"]){
        BBEditBookViewController *editVC = [[BBEditBookViewController alloc]init];
        editVC.book = _book;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"删除这本书"]){
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"确认删除吗？" message:@"删除之后书店里与这本书相关的信息就统统不见了" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"OK", nil];
        [alertview show];
//        DXAlertView *alertview = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"删除之后书店里与这本书相关的信息就统统不见了" leftButtonTitle:@"删" rightButtonTitle:@"Cancel"];
//        alertview.leftBlock = ^(){
//            [_book deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded){
//                    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"删除成功" message:@"您的书已经不见啦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alertview show];
//                }
//            }];
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        };
//        alertview.rightBlock = ^(){
//            
//        };
//        [alertview show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [_book deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"删除成功" message:@"您的书已经不见啦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertview show];
            }
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
