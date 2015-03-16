//
//  BBViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/26.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBViewController.h"
//#import "BBRegisterViewController.h"
#import "BBLoginViewController.h"
#import "BBSettingsTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DXAlertView.h"
#import "BBMyBooksViewController.h"
#import "BBBook.h"
#import "BBBookManager.h"
#import <SVPullToRefresh.h>
#import "BBBookDetailViewController.h"
#import "UMSocial.h"
#import "BBItemTableViewCell.h"
#import "BBNavigationController.h"

@interface BBViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic) NSArray *allbooks;// 所有书本
@property (weak, nonatomic) IBOutlet UITableView *upTableView;

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"BBItemTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"identifier"];
    
    UINavigationItem *item = self.navigationItem;
    item.title = @"欢迎光临";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"burger"] style:UIBarButtonItemStylePlain target:(BBNavigationController *)self.navigationController action:@selector(showMenu)];
    
    [self refreshNavigationItem];
    __weak BBViewController *weakself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakself.tableView reloadData];
    }];
    
    UITableViewCell *footerView = [[UITableViewCell alloc]init];
    footerView.textLabel.text = @"『随时摇一摇，告诉我您的意见，我会及时改进』";
    footerView.textLabel.textAlignment = NSTextAlignmentCenter;
    footerView.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    footerView.textLabel.textColor = [UIColor blueColor];
    self.tableView.tableFooterView =  footerView;
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshNavigationItem];
    [self getData];
}

//刷新数据，pulltorefresh
-(void)getData{
    self.allbooks = [BBBookManager getAllBooks];
    [self.tableView reloadData];
}

//刷新navigation item界面
-(void)refreshNavigationItem{
    self.currentUser = [AVUser currentUser];
    UINavigationItem *item = self.navigationItem;
    if (self.currentUser){
//        UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc]initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
        item.rightBarButtonItem = shareItem;
    }else{
        UIBarButtonItem *registerItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
        item.rightBarButtonItem = registerItem;
    }
}

-(IBAction)login:(id)sender{
    BBLoginViewController *loginVC = [[BBLoginViewController alloc]init];
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self.navigationController pushViewController:registerVC animated:YES];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

-(IBAction)logout:(id)sender{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allbooks count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    BBBook *book = (BBBook*)[self.allbooks objectAtIndex:indexPath.row];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    cell.BigLabel.text = book.bookname;
    cell.smallLabel.text = book.bookOwnerName;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%d", book.price];
    cell.itemImageView.image = [UIImage imageNamed:@"book"];
    if ([cell.BigLabel.text length]>12){
        cell.BigLabel.text = [NSString stringWithFormat:@"%@...", [book.bookname substringToIndex:15]];
    }
    if ([cell.smallLabel.text length]>8){
        cell.smallLabel.text = [NSString stringWithFormat:@"%@...", [book.bookOwnerName substringToIndex:8]];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        cell.itemImageView.image = [UIImage imageNamed:@"book"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (book.photo){
                NSData *imagedata = [book.photo getData];
                UIImage *image = [UIImage imageWithData:imagedata];
                cell.itemImageView.image = image;
                NSLog(@"image loaded");
            }
            [cell setNeedsLayout];
        });
    });
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BBBook *book = (BBBook*)[self.allbooks objectAtIndex:indexPath.row];
    BBBookDetailViewController *detailVC = [[BBBookDetailViewController alloc]init];
    detailVC.book = book;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - RNFrostedSidebarDelegate
//
//- (IBAction)menu:(id)sender {
//    NSArray *images = @[
//                        [UIImage imageNamed:@"user"],
//                        [UIImage imageNamed:@"gear"],
//                        ];
//    NSArray *colors = @[
//                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
//                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
//                        ];
//    
//    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
//    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
//    callout.delegate = self;
//    //    callout.showFromRight = YES;
//    [callout show];
//}
//
//- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
////    NSLog(@"Tapped item at index %lu",(unsigned long)index);
//    if (index == 0){
//        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
//            if (finished) {
//                if (self.currentUser){
//                    BBMyBooksViewController *mybookVC = [[BBMyBooksViewController alloc]init];
//                    [self.navigationController pushViewController:mybookVC animated:YES];
//                }else{
//                    BBLoginViewController *loginVC = [[BBLoginViewController alloc]init];
//                    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
//                    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
//                }
//            }
//        }];
//    }
//    else if (index == 1){
//        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
//            if (finished) {
//                BBSettingsTableViewController *settingsVC = [[BBSettingsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
//                [self.navigationController pushViewController:settingsVC animated:YES];
//            }
//        }];
//    }
////    if (index == 3) {
////        [sidebar dismissAnimated:YES completion:nil];
////    }
//}


#pragma-mark share
-(IBAction)share:(id)sender {
    //    IBActionSheet *shareAs = [[IBActionSheet alloc] initWithTitle:@"分享这本书给..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"微信",@"QQ"]];
    //    [shareAs showInView:self.view];
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    NSString *shareText = [NSString stringWithFormat:@"来布莱克书店看看吧！请搜索app store，『布莱克书店』。（开发者偷懒，暂时没申请各个平台的第三方帐号。。）"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f44c92fd98c5c66b00017e"
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,nil]
                                       delegate:nil];
}


@end
