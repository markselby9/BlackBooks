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
@property(nonatomic, strong) NSMutableIndexSet *optionIndices;
@property(nonatomic, strong) AVUser *currentUser;
@property(nonatomic) NSArray *allbooks; // 所有书本
@property(weak, nonatomic) IBOutlet UITableView *upTableView;

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

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"burger"]
              style:UIBarButtonItemStylePlain
             target:(BBNavigationController *)self.navigationController
             action:@selector(showMenu)];

  [self refreshNavigationItem];
  __weak BBViewController *weakself = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakself.tableView reloadData];
  }];

  UITableViewCell *footerView = [[UITableViewCell alloc] init];
  //  footerView.textLabel.text =
  //      @"『" @"随时摇一摇，告诉我您的意见，我会及时改进』";
  footerView.textLabel.textAlignment = NSTextAlignmentCenter;
  footerView.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
  footerView.textLabel.textColor = [UIColor blueColor];
  self.tableView.tableFooterView = footerView;
  [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refreshNavigationItem];
  [self getData];
}

//刷新数据，pulltorefresh
- (void)getData {
  self.allbooks = [BBBookManager getAllBooks];
  [self.tableView reloadData];
}

//刷新navigation item界面
- (void)refreshNavigationItem {
  self.currentUser = [AVUser currentUser];
  UINavigationItem *item = self.navigationItem;
  if (self.currentUser) {
      
      UIImage *image = [UIImage imageNamed:@"share.png"];
      UIButton *sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [sharebtn setImage:image forState:UIControlStateNormal];
      sharebtn.showsTouchWhenHighlighted = YES;
      sharebtn.frame = CGRectMake(0.0, 3.0, 30, 30);
      [sharebtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithCustomView:sharebtn];
      self.navigationItem.rightBarButtonItem = rightbutton;
  } else {
    UIBarButtonItem *registerItem =
        [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(login:)];
    item.rightBarButtonItem = registerItem;
  }
}

- (IBAction)login:(id)sender {
  BBLoginViewController *loginVC = [[BBLoginViewController alloc] init];
  UINavigationController *naviVC =
      [[UINavigationController alloc] initWithRootViewController:loginVC];
  //    [self.navigationController pushViewController:registerVC animated:YES];
  [self.navigationController presentViewController:naviVC
                                          animated:YES
                                        completion:nil];
}

- (IBAction)logout:(id)sender {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.allbooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BBItemTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"identifier"];

  BBBook *book = (BBBook *)[self.allbooks objectAtIndex:indexPath.row];
  //    [self.tableView registerClass:[UITableViewCell class]
  //    forCellReuseIdentifier:@"identifier"];
  //    UITableViewCell *cell = [tableView
  //    dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];

  cell.priceLabel.text = [NSString stringWithFormat:@"￥%d", book.price];
  cell.itemImageView.image = [UIImage imageNamed:@"book"];
  if ([book.bookname length] > 15) {
    NSString *str = [book.bookname substringToIndex:15];
    NSLog(@"%@", str);
    cell.BigLabel.text = [NSString stringWithFormat:@"%@...", str];
  } else {
    cell.BigLabel.text = book.bookname;
  }
  if ([cell.smallLabel.text length] > 8) {
    NSString *str = [book.bookOwnerName substringToIndex:8];
    NSLog(@"%@", str);
    cell.smallLabel.text = [NSString stringWithFormat:@"%@...", str];
  } else {
    cell.smallLabel.text = book.bookOwnerName;
  }

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //        cell.itemImageView.image = [UIImage imageNamed:@"book"];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (book.photo) {
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

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //  return [self heightForBasicCellAtIndexPath:indexPath];
  return 60.0f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  BBBook *book = (BBBook *)[self.allbooks objectAtIndex:indexPath.row];
  BBBookDetailViewController *detailVC =
      [[BBBookDetailViewController alloc] init];
  detailVC.book = book;

  [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma - mark share
- (IBAction)share:(id)sender {
  //    IBActionSheet *shareAs = [[IBActionSheet alloc]
  //    initWithTitle:@"分享这本书给..." delegate:self
  //    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
  //    otherButtonTitlesArray:@[@"微信",@"QQ"]];
  //    [shareAs showInView:self.view];
  //    [UMSocialConfig
  //    setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
  NSString *shareText =
      [NSString stringWithFormat:@"来马特里二手书店看看吧！请搜索app "
                @"store，『马特里二手书店』。（偷懒，暂时没"
                @"申请各个平台的第三方帐号。。）"];
  [UMSocialSnsService
      presentSnsIconSheetView:self
                       appKey:@"54f44c92fd98c5c66b00017e"
                    shareText:shareText
                   shareImage:[UIImage imageNamed:@"icon.png"]
              shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,
                                                        UMShareToTencent, nil]
                     delegate:nil];
}

@end
