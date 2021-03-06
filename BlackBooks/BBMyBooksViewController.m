//
//  BBMyBooksViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/28.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBMyBooksViewController.h"
#import "BBAddBookViewController.h"
#import "BBBookManager.h"
#import "BBBook.h"
#import <SVPullToRefresh.h>
#import "BBBookDetailViewController.h"
#import "BBNavigationController.h"

@interface BBMyBooksViewController ()

@property(nonatomic) NSArray *booksofuser;

@end

@implementation BBMyBooksViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"我的书架";

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"burger"]
              style:UIBarButtonItemStylePlain
             target:(BBNavigationController *)self.navigationController
             action:@selector(showMenu)];

  UIBarButtonItem *addBookItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                           target:self
                           action:@selector(addBook:)];
  self.navigationItem.rightBarButtonItem = addBookItem;

  __weak BBMyBooksViewController *weakself = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    weakself.booksofuser =
        [BBBookManager getBookOfUsername:([[AVUser currentUser] username])];
    [weakself.tableView reloadData];
  }];
  self.tableView.tableFooterView = [[UIView alloc] init];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.booksofuser =
      [BBBookManager getBookOfUsername:([[AVUser currentUser] username])];
  [self.tableView reloadData];
}

- (IBAction)addBook:(id)sender {
  BBAddBookViewController *addVC = [[BBAddBookViewController alloc] init];
  [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  if (self.booksofuser) {
//      self.tableView.backgroundView = nil;
      UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
      self.tableView.backgroundView = emptyView;
      
      return 1;
  } else {
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                 self.view.bounds.size.height)];
    label.text = @"您" @"暂" @"时" @"还"
        @"没有往书店里放书...\n请轻点右上角按钮添加书本";
    label.textColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.7];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    [label sizeToFit];
    self.tableView.backgroundView = label;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return 0;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [_booksofuser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"reuseIdentifier"];
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                      forIndexPath:indexPath];
  BBBook *book = [_booksofuser objectAtIndex:indexPath.row];
  ;
  NSString *bookname = book.bookname;
  cell.textLabel.text = bookname;
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  BBBook *book = [_booksofuser objectAtIndex:indexPath.row];
  BBBookDetailViewController *detailVC =
      [[BBBookDetailViewController alloc] init];
  detailVC.book = book;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.navigationController pushViewController:detailVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
