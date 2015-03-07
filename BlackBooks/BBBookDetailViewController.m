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

@interface BBBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toobarItem;

@end

@implementation BBBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.book.bookOwnerName isEqualToString:([[AVUser currentUser] username])]){
        self.toobarItem.action = @selector(editBook:);
        self.toobarItem.title = @"修改一下信息";
    }
    
//    self.detailView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addBookView:self.book];
    self.title = self.book.bookname;
    UIBarButtonItem *shareitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBook:)];
    self.navigationItem.rightBarButtonItem = shareitem;
}

-(void)addBookView:(BBBook*)book{
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    label.lineSpacing = 5.0;
    [label appendImage:[UIImage imageNamed:@"user"
                        ] maxSize:CGSizeMake(50, 50)
                margin:UIEdgeInsetsZero
             alignment:M80ImageAlignmentCenter];
    
    NSString *text  = [self textForView];
    [label appendText:text];
    
    label.frame = CGRectInset(self.detailView.bounds,20,20);
    [label setTextAlignment:kCTTextAlignmentNatural];
    
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

- (IBAction)takeBook:(id)sender {
    UIActionSheet *contactUserSheet = [[UIActionSheet alloc]initWithTitle:@"联系书的主人" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看联系方式", nil];
    [contactUserSheet showInView:self.view];
}

-(IBAction)editBook:(id)sender{
    BBEditBookViewController *editVC = [[BBEditBookViewController alloc]init];
    editVC.book = _book;
    [self.navigationController pushViewController:editVC animated:YES];
}

//http://dev.umeng.com/social/ios/detail-share#1_3
-(IBAction)shareBook:(id)sender {
//    IBActionSheet *shareAs = [[IBActionSheet alloc] initWithTitle:@"分享这本书给..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"微信",@"QQ"]];
    //    [shareAs showInView:self.view];
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f44c92fd98c5c66b00017e"
                                      shareText:@"分享一下这个书店"
                                     shareImage:[UIImage imageNamed:@"like.png"]
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
    
}

@end
