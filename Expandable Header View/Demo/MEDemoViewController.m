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

@property(nonatomic, weak) IBOutlet MEExpandableHeaderView *headerView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, retain) NSArray *elementsList;

@end

@implementation MEDemoViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupElements];
    [self setupHeaderView];
}

#pragma mark - Setup

- (void)setupHeaderView
{
    assert([self.headerView isKindOfClass:[MEExpandableHeaderView class]]);
    assert([self.tableView isKindOfClass:[UITableView class]]);
    
    self.headerView.backgroundImage = [UIImage imageNamed:@"beach"];
    
    NSArray *pages = @[[[self class] createPageViewWithText:@"First page"],
                       [[self class] createPageViewWithText:@"Second page"],
                       [[self class] createPageViewWithText:@"Third page"],
                       [[self class] createPageViewWithText:@"Fourth page"]];
    
    self.headerView.pages = pages;
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupElements
{
    static NSUInteger const kElementsCount = 10;
    
    NSMutableArray *elementsList = [NSMutableArray arrayWithCapacity:kElementsCount];
    
    for (NSUInteger index = 1; index <= kElementsCount; index++)
    {
        [elementsList addObject:[NSString stringWithFormat:@"Row %lu", (unsigned long)index]];
    }
    
    self.elementsList = [NSArray arrayWithArray:elementsList];
}

#pragma mark - Content

+ (UIView*)createPageViewWithText:(NSString*)text
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
    return [self.elementsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *rowText = [self.elementsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = rowText;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
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
