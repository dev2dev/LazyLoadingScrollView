//
//  LazyLoadingScrollViewAppDelegate.h
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright Douglass Turner Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyLoadingScrollViewAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
	
    UIWindow				*_window;
    UIScrollView			*_scrollView;
	UIView					*_containerView;
	
	NSMutableSet			*_pageSet;
	NSMutableSet			*_pageSlotSet;
	
	CGPoint					_initialContentOffset;
	
	NSRange					_basepairRange;
	
	NSUInteger				_basepairPerView;
	
	NSUInteger				_maximumBasepairDisplayed;
	NSUInteger				_minimunBasepairDisplayed;
	
    NSMutableData			*_sequenceData;
    NSString				*_sequenceString;	
	
    UIActivityIndicatorView	*_spinner;
	
	NSOperationQueue		*_operationQueue;
	
	// content resetting stuff
	BOOL					_doRecenterContentView;
	CGPoint					_contentOffsetFromCenter;
	CGSize					_contentTileSize;
	
}

@property (nonatomic, retain) IBOutlet UIWindow			*window;
@property (nonatomic, retain) IBOutlet UIScrollView		*scrollView;
@property (nonatomic, retain) UIView					*containerView;

@property (nonatomic, retain) NSMutableSet		*pageSet;
@property (nonatomic, retain) NSMutableSet		*pageSlotSet;

@property(nonatomic) CGPoint					initialContentOffset;

@property(nonatomic) NSRange					basepairRange;

@property(nonatomic) NSUInteger					basepairPerView;

@property(nonatomic) NSUInteger					minimunBasepairDisplayed;
@property(nonatomic) NSUInteger					maximumBasepairDisplayed;

@property (nonatomic, retain) NSMutableData		*sequenceData;
@property (nonatomic, retain) NSString			*sequenceString;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*spinner;

@property (nonatomic, retain) NSOperationQueue	*operationQueue;

@property(nonatomic) BOOL						doRecenterContentView;
@property(nonatomic) CGPoint					contentOffsetFromCenter;
@property(nonatomic) CGSize						contentTileSize;

+ (UIColor *)colorWithIndex:(NSUInteger)index;

@end

