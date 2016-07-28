//
//  MEExpandableHeaderView.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEExpandableHeaderView.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface MEExpandableHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImage *originalBackgroundImage;
@property(nonatomic, assign) CGPoint previousContentOffset;
@property(nonatomic, assign) CGFloat originalHeight;

@property(nonatomic, strong, readwrite) UIImageView *backgroundImageView;
@property(nonatomic, strong, readwrite) UIScrollView *pagesScrollView;
@property(nonatomic, strong, readwrite) UIPageControl *pageControl;

@end

@implementation MEExpandableHeaderView

#pragma mark - Init

- (void)commonInit
{
    _originalHeight = self.frame.size.height;
    _previousContentOffset = CGPointZero;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

#pragma mark - Resize

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resizePages];
}

#pragma mark - Setup

- (void)setBackgroundImage:(UIImage*)backgroundImage
{
    assert(backgroundImage == nil || [backgroundImage isKindOfClass:[UIImage class]]);
    
    _backgroundImage = backgroundImage;
    _originalBackgroundImage = backgroundImage;
    
    if (backgroundImage != nil &&
        self.backgroundImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        
        imageView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        
        [self insertSubview:imageView atIndex:0];
        
        self.backgroundImageView = imageView;
    }
    
    self.backgroundImageView.image = backgroundImage;
}

- (void)setPages:(NSArray*)pages
{
    assert([pages isKindOfClass:[NSArray class]] && [pages count] > 0);
    
    _pages = pages;
    
    if (self.pagesScrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        [scrollView setDelegate:self];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        
        scrollView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:scrollView];
        self.pagesScrollView = scrollView;
    }
    
    [self setupPages:pages];
    [self setupPageControl:[pages count]];
}

- (void)setupPages:(NSArray*)pages
{
    assert([self.pagesScrollView isKindOfClass:[UIScrollView class]]);
    
    for (UIView *page in self.pages)
    {
        assert([page isKindOfClass:[UIView class]]);
        [self.pagesScrollView addSubview:page];
    }
    
    [self resizePages];
}

- (void)resizePages
{
    assert([self.pagesScrollView isKindOfClass:[UIScrollView class]]);
    
    CGFloat posX = 0.0;
    CGPoint center;
    center.y = self.bounds.size.height / 2.0;
    
    for (UIView *page in self.pages)
    {
        assert([page isKindOfClass:[UIView class]]);
        assert(page.superview != nil);
        
        center.x = posX + self.bounds.size.width / 2.0;
        page.center = center;
        
        posX += self.bounds.size.width;
    }
    
    [self.pagesScrollView setContentSize:CGSizeMake(posX, self.bounds.size.height)];
    [self scrollToPage:self.pageControl.currentPage
              animated:NO];
}

- (void)setupPageControl:(NSUInteger)pagesCount
{
    assert(pagesCount > 0);
    
    if (pagesCount > 1)
    {
        static CGFloat const kPageControlPadding = 7.0;
        static CGRect const kPageControlDefaultFrame = {0, 0, 20, 20};
        
        if (self.pageControl == nil)
        {
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:kPageControlDefaultFrame];
            
            [pageControl addTarget:self
                            action:@selector(pageControlChanged)
                  forControlEvents:UIControlEventValueChanged];
        
            pageControl.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin;
            
            UIColor *backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            [pageControl setBackgroundColor:backgroundColor];
            
            CGSize pageControlSize = [pageControl sizeForNumberOfPages:pagesCount];
            
            CGRect pageFrame = pageControl.frame;
            pageFrame.size.width = pageControlSize.width + kPageControlPadding * 2;
            pageFrame.origin.x = (self.bounds.size.width - pageFrame.size.width) / 2.0;
            pageFrame.origin.y = self.bounds.size.height - (pageFrame.size.height + kPageControlPadding);
            
            pageControl.frame = pageFrame;
        
            pageControl.layer.cornerRadius = pageControl.frame.size.height / 2.0;
            
            [self addSubview:pageControl];
            
            self.pageControl = pageControl;
        }
        
        [self.pageControl setNumberOfPages:pagesCount];
        [self.pageControl setCurrentPage:0];
    }
    else
    {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
}

#pragma mark - Page

- (void)pageControlChanged
{
    [self scrollToPage:self.pageControl.currentPage
              animated:YES];
}

- (void)scrollToPage:(NSUInteger)pageNumber
            animated:(BOOL)animated
{
    assert([self.pagesScrollView isKindOfClass:[UIScrollView class]]);
    
    CGPoint newOffset = CGPointMake(self.bounds.size.width * pageNumber, 0);
    [self.pagesScrollView setContentOffset:newOffset
                                  animated:animated];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndScrolling:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView
{
    if (scrollView == self.pagesScrollView)
    {
        assert([self.pageControl isKindOfClass:[UIPageControl class]]);

        NSUInteger currentPage = scrollView.contentOffset.x / self.bounds.size.width;
        [self.pageControl setCurrentPage:currentPage];
    }
}

#pragma mark - Public

- (void)offsetDidUpdate:(CGPoint)newOffset
{
    if (newOffset.y <= 0)
    {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y / 2.0);
        
        CGFloat scaleFactor = (self.originalHeight - newOffset.y) / self.originalHeight;
        
        CGAffineTransform translateAndZoom = CGAffineTransformScale(translate, scaleFactor, scaleFactor);
        
        float radius = -newOffset.y / 40.0;
        self.backgroundImageView.image = [self.originalBackgroundImage applyBlurWithRadius:radius
                                                                                 tintColor:nil
                                                                     saturationDeltaFactor:1.0
                                                                                 maskImage:nil];
        self.backgroundImageView.transform = translateAndZoom;
        self.pagesScrollView.transform = translate;
    }
    
    self.previousContentOffset = newOffset;
}

@end
