//
//  MEExpandableHeaderView.h
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEExpandableHeaderView : UIView

@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, strong) NSArray *pages;

@property(nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property(nonatomic, strong, readonly) UIScrollView *pagesScrollView;
@property(nonatomic, strong, readonly) UIPageControl *pageControl;



/**
 *	@brief		This method is used to get notified when the container table view's offset was
 *				updated.
 *
 *	@details	When this method is called, it will update current zoom level and blur level
 *				of the background image. The value Y of the new offset will be user for that.
 *				The pages' content will be kept centered.
 *
 *	@param		newOffset			New offset value.
 *
 */
- (void)offsetDidUpdate:(CGPoint)newOffset;

@end
