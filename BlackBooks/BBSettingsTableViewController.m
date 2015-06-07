//
//  BBSettingsTableViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBSettingsTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "BBSetUserViewController.h"
#import "BBLoginViewController.h"
#import "BBChangePasswordViewController.h"
#import "BBTucaoViewController.h"
#import "DXAlertView.h"
#import "BBAboutmeViewController.h"
#import <PgySDK/PgyManager.h>
#import "BBNavigationController.h"

@interface BBSettingsTableViewController ()
@property(nonatomic) NSMutableArray *settingsArray;
@property(nonatomic) NSMutableArray *userArray;
@property(nonatomic) NSMutableArray *aboutArray;
@property(nonatomic) AVUser *currentUser;

@end

@implementation BBSettingsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.dataSource = self;

  self.title = @"设置";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"burger"]
              style:UIBarButtonItemStylePlain
             target:(BBNavigationController *)self.navigationController
             action:@selector(showMenu)];

//  [[PgyManager sharedPgyManager] checkUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refreshView];

  [self.tableView reloadData];
}

- (void)refreshView {
  self.currentUser = [AVUser currentUser];

  self.userArray = [[NSMutableArray alloc] init];
  [self.userArray addObject:@"个人资料设置"];
  [self.userArray addObject:@"密码修改"];
  //    [self.userArray addObject:@"我要吐槽（摇一摇也可以！）"];
  if (self.currentUser) {
    [self.userArray addObject:@"登出当前帐号"];
  }

  self.aboutArray = [[NSMutableArray alloc] init];
  [self.aboutArray addObject:@"关于 Mark Books ，我的开发计划"];
  self.settingsArray = [[NSMutableArray alloc] init];
  [self.settingsArray addObject:self.userArray];
  [self.settingsArray addObject:self.aboutArray];

  UITableViewCell *footercell =
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil];
  if (self.currentUser) {
    footercell.textLabel.text =@"随时摇一摇手机，提供您的最新反馈！";
  } else {
    footercell.textLabel.text = @"请先注册或登录您的书店帐号.";
  }
  self.tableView.tableFooterView = footercell;
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return [self.settingsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [[self.settingsArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"settingsidentifier"];
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"settingsidentifier"
                                      forIndexPath:indexPath];

  if (indexPath.section == 0) {
    cell.textLabel.text = [self.userArray objectAtIndex:indexPath.row];
  } else {
    cell.textLabel.text = [self.aboutArray objectAtIndex:indexPath.row];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  if (!self.currentUser) {
    BBLoginViewController *loginVC = [[BBLoginViewController alloc] init];
    UINavigationController *naviVC =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:naviVC
                                            animated:YES
                                          completion:nil];
  } else {
    if (indexPath.section == 0) {
      if ([cell.textLabel.text isEqualToString:@"个人资料设置"]) {
        BBSetUserViewController *userVC =
            [[BBSetUserViewController alloc] init];
        userVC.user = self.currentUser;
        [self.navigationController pushViewController:userVC animated:YES];
      } else if ([cell.textLabel.text isEqualToString:@"密码修改"]) {
        BBChangePasswordViewController *changeVC =
            [[BBChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changeVC animated:YES];
      }
      //            else if ([cell.textLabel.text
      //            isEqualToString:@"邮箱暂未验证，点此验证"]){
      //
      //            }
      //            else if ([cell.textLabel.text isEqualToString:@"我要吐槽"]){
      //                BBTucaoViewController *tucaoVC = [[BBTucaoViewController
      //                alloc]init];
      //                [self.navigationController pushViewController:tucaoVC
      //                animated:YES];
      //            }
      else if ([cell.textLabel.text isEqualToString:@"登出当前帐号"]) {
        DXAlertView *alert =
            [[DXAlertView alloc] initWithTitle:@"Logout"
                                   contentText:@"是否登出当前帐户？"
                               leftButtonTitle:@"Yes"
                              rightButtonTitle:@"No"];
        [alert show];
        alert.leftBlock = ^() {
          [AVUser logOut]; //清除缓存用户对象
          self.currentUser = [AVUser currentUser];
          [self refreshView];
          //                [self refreshNavigationItem];
        };
        alert.dismissBlock = ^() {
          [self refreshView];
        };
      }
    } else if (indexPath.section == 1) {
      if (indexPath.row == 0) {
        BBAboutmeViewController *aboutmeVC =
            [[BBAboutmeViewController alloc] init];
        [self.navigationController pushViewController:aboutmeVC animated:YES];
      }
    }
  }
}

@end
