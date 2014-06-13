//
//  MEDemoViewController.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEDemoViewController.h"
#import "MEExpandableHeaderView.h"

@interface MEDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) MEExpandableHeaderView *headerView;
@property(nonatomic, retain) NSArray *elementsList;

@end

@implementation MEDemoViewController

#pragma mark - NSObject lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Expandable Header View";
    }
    return self;
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupElements];
    [self setupHeaderView];
    
}

#pragma mark - Setup

- (void)setupHeaderView
{
    CGSize headerViewSize = CGSizeMake(320, 200);
    UIImage *backgroundImage = [UIImage imageNamed:@"beach"];
    NSArray *pages = @[[self createPageViewWithText:@"First page"],
                       [self createPageViewWithText:@"Second page"],
                       [self createPageViewWithText:@"Third page"],
                       [self createPageViewWithText:@"Fourth page"]];
    MEExpandableHeaderView *headerView = [[MEExpandableHeaderView alloc] initWithSize:headerViewSize
                                                                      backgroundImage:backgroundImage
                                                                         contentPages:pages];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

- (void)setupElements
{
    self.elementsList = @[@"Row 1", @"Row 2", @"Row 3", @"Row 4", @"Row 5", @"Row 6", @"Row 7", @"Row 8", @"Row 9", @"Row 10"];
}


#pragma mark - Content

- (UIView*)createPageViewWithText:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
    
    label.font = [UIFont boldSystemFontOfSize:27.0];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = text;
    
    return label;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.elementsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellIdentifier = @"TableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *rowText = [self.elementsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = rowText;
    
    return cell;

}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == self.tableView)
	{
        [self.headerView offsetDidUpdate:scrollView.contentOffset];
	}
}

@end
