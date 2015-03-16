//
//  BBMenuController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/10.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBMenuController.h"
#import "BBNavigationController.h"
#import "BBViewController.h"
#import "BBMyBooksViewController.h"
#import "BBSettingsTableViewController.h"
#import "BBAboutmeViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface BBMenuController ()

@property (nonatomic) NSMutableArray *settingsArray1;
@property (nonatomic) NSMutableArray *settingsArray2;

@end

@implementation BBMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsArray1 = [[NSMutableArray alloc]initWithArray:@[@"书店首页", @"我的书店", @"以书会友(施工中)"]];
    self.settingsArray2 = [[NSMutableArray alloc]initWithArray:@[@"系统设置"]];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    AVUser *currentuser = [AVUser currentUser];
//    
//    self.tableView.tableHeaderView = ({
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        imageView.image = [UIImage imageNamed:@"book"];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 50.0;
//        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        imageView.layer.borderWidth = 3.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
//        label.text = @"尚未登录";
//        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        [label sizeToFit];
//        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        //登录了
//        if (currentuser){
//            label.text = currentuser.username;
//            AVFile *imagefile = [currentuser objectForKey:@"image"];
//            if (imagefile){
//                NSData *imagedata = [imagefile getData];
//                UIImage *image = [UIImage imageWithData:imagedata];
//                imageView.image = image;
//            }
//        }
//        [view addSubview:imageView];
//        [view addSubview:label];
//        view;
//    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AVUser *currentuser = [AVUser currentUser];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"book"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"尚未登录";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        //登录了
        if (currentuser){
            label.text = currentuser.username;
            AVFile *imagefile = [currentuser objectForKey:@"image"];
            if (imagefile){
                NSData *imagedata = [imagefile getData];
                UIImage *image = [UIImage imageWithData:imagedata];
                imageView.image = image;
            }
        }
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"设置";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            BBViewController *homeViewController = [[BBViewController alloc] init];
            BBNavigationController *navigationController = [[BBNavigationController alloc] initWithRootViewController:homeViewController];
            self.frostedViewController.contentViewController = navigationController;
        }
        if (indexPath.row == 1){
            BBMyBooksViewController *myBooksVC = [[BBMyBooksViewController alloc]init];
            BBNavigationController *navi = [[BBNavigationController alloc]initWithRootViewController:myBooksVC];
            self.frostedViewController.contentViewController = navi;
        }
    }
    if (indexPath.section == 1){
        if (indexPath.row == 0){
            BBSettingsTableViewController *settingsVC = [[BBSettingsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
            BBNavigationController *navi = [[BBNavigationController alloc]initWithRootViewController:settingsVC];
            self.frostedViewController.contentViewController = navi;
        }
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0){
        return [self.settingsArray1 count];
    }else if (sectionIndex == 1){
        return [self.settingsArray2 count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.settingsArray1[indexPath.row];
    } else {
        
        cell.textLabel.text = self.settingsArray2[indexPath.row];
    }
    
    return cell;
}

@end
