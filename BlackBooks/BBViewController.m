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

@interface BBViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic) NSArray *allbooks;// 所有书本

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINavigationItem *item = self.navigationItem;
    item.title = @"Welcome";
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"burger"] style:UIBarButtonItemStylePlain target:self action:@selector(menu:)];
    item.leftBarButtonItem = menuItem;
    
    [self refreshNavigationItem];
    
    __weak BBViewController *weakself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakself.tableView reloadData];
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
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
        item.rightBarButtonItem = nil;
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
    BBBook *book = (BBBook*)[self.allbooks objectAtIndex:indexPath.row];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    cell.textLabel.text = book.bookname;
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

- (IBAction)menu:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"user"],
                        [UIImage imageNamed:@"gear"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
//    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    if (index == 0){
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                if (self.currentUser){
                    BBMyBooksViewController *mybookVC = [[BBMyBooksViewController alloc]init];
                    [self.navigationController pushViewController:mybookVC animated:YES];
                }else{
                    BBLoginViewController *loginVC = [[BBLoginViewController alloc]init];
                    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
                    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
                }
            }
        }];
    }
    else if (index == 1){
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                BBSettingsTableViewController *settingsVC = [[BBSettingsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:settingsVC animated:YES];
            }
        }];
    }
//    if (index == 3) {
//        [sidebar dismissAnimated:YES completion:nil];
//    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

@end
