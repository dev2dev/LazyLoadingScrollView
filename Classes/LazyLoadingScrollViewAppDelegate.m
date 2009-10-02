//
//  LazyLoadingScrollViewAppDelegate.m
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright Douglass Turner Consulting 2009. All rights reserved.
//

#import "LazyLoadingScrollViewAppDelegate.h"
#import "MyViewController.h"

static NSUInteger kNumberOfPages = 8;

@interface LazyLoadingScrollViewAppDelegate (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;

- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation LazyLoadingScrollViewAppDelegate

@synthesize viewControllers;
@synthesize scrollView;
@synthesize window;

- (void)dealloc {
	
    [viewControllers	release];
    [scrollView			release];
    [window				release];
	
    [super				dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
    // a page is the width of the scroll view
	//    scrollView.pagingEnabled = YES;
    scrollView.pagingEnabled = NO;
	
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
	NSLog(@"scrollView.contentSize: %f %f", scrollView.contentSize.width, scrollView.contentSize.height);
	
	NSLog(@"scrollView.bounds: %f %f %f %f",  
		  scrollView.bounds.origin.x,  scrollView.bounds.origin.y,  scrollView.bounds.size.width,  scrollView.bounds.size.height);
	
	//    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
	
    scrollView.showsVerticalScrollIndicator = NO;
	
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

@end
