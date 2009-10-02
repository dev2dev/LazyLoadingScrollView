//
//  LazyLoadingScrollViewAppDelegate.m
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright Douglass Turner Consulting 2009. All rights reserved.
//

#import "LazyLoadingScrollViewAppDelegate.h"
#import "MyViewController.h"

static NSUInteger kNumberOfPages = 8 * 2;

@interface LazyLoadingScrollViewAppDelegate (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;

- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation LazyLoadingScrollViewAppDelegate

@synthesize pageSet=_pageSet;
@synthesize viewList=_viewList;
@synthesize viewControllers;
@synthesize containerView=_containerView;
@synthesize scrollView;
@synthesize window;

- (void)dealloc {
	
    [_pageSet			release];
    [_viewList			release];
    [viewControllers	release];
    [_containerView		release];
    [scrollView			release];
    [window				release];
	
    [super				dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    NSMutableArray *controllers = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *views		= [[[NSMutableArray alloc] init] autorelease];
	
    for (int i = 0; i < kNumberOfPages; i++) {
        [controllers	addObject:[NSNull null]];
        [views			addObject:[NSNull null]];
    }
    self.viewControllers	= controllers;
    self.viewList			= views;
	
    // a page is the width of the scroll view
	//    scrollView.pagingEnabled = YES;
    scrollView.pagingEnabled = NO;
	
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
	NSLog(@"scrollView.contentSize: %f %f", scrollView.contentSize.width, scrollView.contentSize.height);
	
	
	//    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
	
    scrollView.showsVerticalScrollIndicator = NO;
	
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
	CGRect containerViewFrame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
	self.containerView = [[[UIView alloc] initWithFrame:containerViewFrame] autorelease];
	[self.scrollView addSubview:self.containerView];
	
	NSLog(@"scrollView -  frame: %f %f %f %f", 
		  scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
	NSLog(@"scrollView - bounds: %f %f %f %f",  
		  scrollView.bounds.origin.x,  scrollView.bounds.origin.y,  scrollView.bounds.size.width,  scrollView.bounds.size.height);
	
	NSLog(@"containerView -  frame: %f %f %f %f", 
		  _containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, _containerView.frame.size.height);
	NSLog(@"containerView - bounds: %f %f %f %f",  
		  _containerView.bounds.origin.x,  _containerView.bounds.origin.y,  _containerView.bounds.size.width,  _containerView.bounds.size.height);
	
	self.pageSet = [NSMutableSet set];
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	
	NSLog(@"scrollViewContentOffset: %f %f",  scrollView.contentOffset.x, scrollView.contentOffset.y);
	
}

- (void)loadScrollViewWithPage:(int)page {
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
	
    UIView *view = [self.viewList objectAtIndex:page];
	
    if ((NSNull *)view == [NSNull null]) {
		
        view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		
        [self.viewList replaceObjectAtIndex:page withObject:view];
		
    } // if ((NSNull *)view == [NSNull null])
	
    if (nil == view.superview) {
		
		CGFloat horizontalOffsetX	= ((float) page) * scrollView.bounds.size.width;
        view.frame					= CGRectMake(horizontalOffsetX, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
		
//		NSLog(@"subview %d -  frame: %f %f %f %f", page,  view.frame.origin.x,  view.frame.origin.y,  view.frame.size.width,  view.frame.size.height);
//		NSLog(@"subview %d - bounds: %f %f %f %f", page, view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
		
		int zeroTo255;
		
		zeroTo255 = (arc4random() % 255) + 1;
		float r = ((float)zeroTo255) / 255.0;
		
		zeroTo255 = (arc4random() % 255) + 1;
		float g = ((float)zeroTo255) / 255.0;
		
		zeroTo255 = (arc4random() % 255) + 1;
		float b = ((float)zeroTo255) / 255.0;
		
		view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
		view.tag			= page;
		
        [self.containerView addSubview:view];

    }
	
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

//	NSLog(@"scrollViewDidScroll");
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[self.pageSet removeAllObjects];
	
	for (UIView *v in self.containerView.subviews) {
		
		[self.pageSet addObject:[NSNumber numberWithInteger:v.tag]];

		CGRect bounds = [v convertRect:v.bounds toView:scrollView];
		
		if (CGRectIntersectsRect(bounds, scrollView.bounds)) {
			
//			NSLog(@"View(%d) is visible", v.tag);	
		} else {
			
//			NSLog(@"View(%d) is hidden", v.tag);	
		}
		
	} // for (self.containerView.subviews)
	
//	NSLog(@"pageSet is %@", self.pageSet);
	
	NSMutableSet *candidatePageSet = 
	[NSMutableSet setWithArray:[NSArray 
								arrayWithObjects:
								[NSNumber numberWithInteger:(page - 1)], 
								[NSNumber numberWithInteger:(page    )], 
								[NSNumber numberWithInteger:(page + 1)], 
								nil]];
	
//	NSLog(@"candidatePageSet is %@", candidatePageSet);
	
	[candidatePageSet minusSet:self.pageSet];
//	NSLog(@"minusSet is %@", candidatePageSet);
	
	for (NSNumber *n in candidatePageSet) {
		
//		NSLog(@"Page: %d", [n integerValue]);
		
		[self loadScrollViewWithPage:[n integerValue]];
		
	} // for (candidatePageSet)

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

@end
