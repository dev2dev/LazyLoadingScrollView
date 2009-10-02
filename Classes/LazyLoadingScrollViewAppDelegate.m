//
//  LazyLoadingScrollViewAppDelegate.m
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright Douglass Turner Consulting 2009. All rights reserved.
//

#import "LazyLoadingScrollViewAppDelegate.h"
#import "EchoSequenceDataRangeView.h"
#import "SequenceDataLoadingOperation.h"
#import "ConstrainedView.h"

static NSArray *LazyLoadingScrollViewAppDelegateColorList = nil;

static NSUInteger kNumberOfPages = 3;

@interface LazyLoadingScrollViewAppDelegate (PrivateMethods)

- (void)doBitBucket;

- (void)didFinishRetrievingSequenceData:(NSDictionary *)results;

- (void)doSomething;
- (void)doSomethingWithThisThang:(NSString *)thisThang;
- (void)doSomethingWithThisThang:(NSString *)thisThang andAlsoThisThang:(NSString *)alsoThisThang;

- (void)loadScrollViewFromPageSet:(NSMutableSet *)pageSet width:(float)width;

@end

@implementation LazyLoadingScrollViewAppDelegate

@synthesize window=_window;
@synthesize scrollView=_scrollView;
@synthesize containerView=_containerView;

@synthesize pageSet=_pageSet;
@synthesize pageSlotSet=_pageSlotSet;

@synthesize initialContentOffset=_initialContentOffset;

@synthesize basepairRange=_basepairRange;

@synthesize basepairPerView=_basepairPerView;

@synthesize minimunBasepairDisplayed=_minimunBasepairDisplayed;
@synthesize maximumBasepairDisplayed=_maximumBasepairDisplayed;

@synthesize sequenceData=_sequenceData;
@synthesize sequenceString=_sequenceString;

@synthesize spinner=_spinner;

@synthesize operationQueue=_operationQueue;

@synthesize doRecenterContentView=_doRecenterContentView;
@synthesize contentOffsetFromCenter=_contentOffsetFromCenter;
@synthesize contentTileSize=_contentTileSize;

- (void)dealloc {
	
    [_pageSet			release];
    [_pageSlotSet		release];
	
    [_containerView		release];
    [_scrollView		release];
    [_window			release];
	
    [_sequenceData		release];
    [_sequenceString	release];
	
	[_spinner			release];
	
    [_operationQueue	release];
	
    [super				dealloc];
}

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    self.scrollView.showsHorizontalScrollIndicator	= YES;
    self.scrollView.showsVerticalScrollIndicator	= NO;
    self.scrollView.scrollsToTop					= NO;

	self.scrollView.bounces							= NO;
    self.scrollView.bouncesZoom						= NO;
	
	self.scrollView.indicatorStyle					= UIScrollViewIndicatorStyleDefault;
	
	self.scrollView.delegate						= self;
	
//	self.scrollView.decelerationRate				= UIScrollViewDecelerationRateNormal;
	self.scrollView.decelerationRate				= UIScrollViewDecelerationRateFast;
	
	
	self.contentTileSize		= CGSizeMake(self.scrollView.bounds.size.width * 2, self.scrollView.bounds.size.height);
	self.scrollView.contentSize	= CGSizeMake(self.contentTileSize.width * kNumberOfPages, self.contentTileSize.height);
	
	CGRect containerViewFrame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
	self.containerView = [[[ConstrainedView alloc] initWithFrame:containerViewFrame] autorelease];
	self.containerView.backgroundColor = [UIColor whiteColor];
	self.containerView.tag = 999;
	
	[self.scrollView addSubview:self.containerView];
	
	// Position scrollView in the center of it's excursion
	float exe = (self.scrollView.contentSize.width - self.scrollView.bounds.size.width) / 2.0;
	float wye = (self.scrollView.contentSize.height - self.scrollView.bounds.size.height) / 2.0;
	[self.scrollView setContentOffset:CGPointMake(exe, wye)];
	
	// Record initial content offset
	self.initialContentOffset	= self.scrollView.contentOffset;
	
	// Do not recenter content view at this point in time
	self.doRecenterContentView	= NO;
	
	// Make a list of view tags and create views with those tags.
	self.pageSet = [NSSet setWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
	[self loadScrollViewFromPageSet:self.pageSet width:self.contentTileSize.width];
	
	// We only want our operation queue to perform one operation at a time.
	_operationQueue = [[NSOperationQueue alloc] init];
	[_operationQueue setMaxConcurrentOperationCount:1];

	self.basepairPerView = 1000;
	self.basepairRange = NSMakeRange((NSUInteger)1e6, (NSUInteger)1e4);
	// Build a sequence data request package
	NSDictionary *requestPackage = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSString stringWithString:@"1"],													@"chromosome",
									[NSNumber numberWithInt:self.basepairRange.location],								@"basepairStart",
									[NSNumber numberWithInt:(self.basepairRange.length + self.basepairRange.location)],	@"basepairEnd",
								   nil];
	
	// Create the operation to retrieve the sequence data
	SequenceDataLoadingOperation *operation = 
	[[[SequenceDataLoadingOperation alloc]initWithSequenceDataRequestPackage:requestPackage 
																	  target:self 
																	  action:@selector(didFinishRetrievingSequenceData:)] autorelease];
	
	[self.spinner startAnimating];
	
	// Enqueue the request. Let magic happen.
	[self.operationQueue addOperation:operation];

}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
//	NSLog(@"scrollViewDidScroll: dragging(%d)", scrollView.dragging);
		
	
	// For some reason, this method is called at app startup.
	// We only want to deal with recentering the content view when
	// the user is actually dragging.
	if (scrollView.dragging == NO) {
		
		return;
		
	} // if (scrollView.dragging == NO)
	
	
	self.contentOffsetFromCenter = 
	CGPointMake(scrollView.contentOffset.x - self.initialContentOffset.x, scrollView.contentOffset.y - self.initialContentOffset.y);
		
	if (fabs(self.contentOffsetFromCenter.x) > self.contentTileSize.width) {
		
		if (self.doRecenterContentView == NO) {
			
			self.doRecenterContentView = YES;
			
		} // if (self.doRecenterContentView == NO)
		
//		NSLog(@"contentOffsetFromCenter(%f) > contentTileSize(%f). scrollViewDidEndDragging: will reposition contentView", 
//			  self.contentOffsetFromCenter.x, self.contentTileSize.width);
		
	} // if (fabs(self.contentOffsetFromCenter.x) > self.contentTileSize.width)
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	NSLog(@"LazyLoadingScrollViewAppDelegate - scrollViewWillBeginDragging:");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

	// Ensure the user hasn't triggered a recenter - in scrollViewDidScroll: - but then dragged back from the
	// triggering threshold.
	if (fabs(self.contentOffsetFromCenter.x) <= self.contentTileSize.width) {
		
		return;
		
	} // if (fabs(self.contentOffsetFromCenter.x) <= self.contentTileSize.width)
	
	if (self.doRecenterContentView == YES) {
		
		// Handle boundary conditions. 
		if (self.contentOffsetFromCenter.x < 0.0) {
			
			EchoSequenceDataRangeView *v = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:0];
			NSLog(@"Boundary Condition Test: %@", v);
			
			if (v.basepairSubrange.location - v.basepairSubrange.length < v.basepairRange.location) {
				
				NSLog(@"<-- BAILING <--");
				self.doRecenterContentView = NO;
				
				return;		
				
			} // if (v.basepairSubrange.location - v.basepairSubrange.length < v.basepairRange.location)
			
		} else {
			
			EchoSequenceDataRangeView *v = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:([self.containerView.subviews count] - 1)];
			NSLog(@"Boundary Condition Test: %@", v);
			
			NSUInteger basepairSubrangeEnd	= v.basepairSubrange.location + v.basepairSubrange.length;
			NSUInteger basepairRangeEnd		= v.basepairRange.location + v.basepairRange.length;
			
			if (basepairSubrangeEnd >= basepairRangeEnd) {
				
				NSLog(@"--> BAILING -->");
				self.doRecenterContentView = NO;
				
				return;		
				
			} // if (basepairSubrangeEnd > basepairRangeEnd)
			
		}
		
		
		
		
		
		
		
		
		// Create a list for shifting view frames. The views shift has a cylindrical topology. the direction of shift
		// is dependent on the sign - i/+ - of contentOffsetFromCenter
		NSArray *viewFrameShiftIndexList = nil;
		
		// We need to compensate for the distance beyond the threshold that triggers recentering. We add this compensation to
		// the initialContentOffset to arrive at the correct offset.
		float compensation;
		
		if (self.contentOffsetFromCenter.x < 0.0) {

			viewFrameShiftIndexList = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:0], nil];
			compensation			= self.contentOffsetFromCenter.x + self.contentTileSize.width;
		} else {
			
			viewFrameShiftIndexList	= [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
			compensation			= self.contentOffsetFromCenter.x - self.contentTileSize.width;
		}
		
		CGPoint compensatedContentOffset = CGPointMake(self.initialContentOffset.x + compensation, self.initialContentOffset.y);
		[self.scrollView setContentOffset:compensatedContentOffset];

		// In addition to re-centering the container view, we need to shuffle the frames of the subviews in a cylindrical topology.
		// 0 -> 1 -> 2 -> 0 -> 1 -> 2 
		// or 
		// 2 -> 1 -> 0 -> 2 -> 1 -> 0
		//
		// Make list of all the frames
		NSMutableArray *viewFrames = [NSMutableArray array];
		for (NSUInteger i = 0; i < [self.containerView.subviews count]; i++) {
			
			UIView *v = [self.containerView viewWithTag:i];
			[viewFrames insertObject:[NSValue valueWithCGRect:v.frame] atIndex:i];

		} // for ([self.containerView.subviews count])
		
		// Shuffle the frames using viewFrameShiftIndex as an indirection table
		for (NSUInteger i = 0; i < [self.containerView.subviews count]; i++) {
			
			// Find the frame to shift this view to
			NSUInteger viewFrameShiftIndex = [[viewFrameShiftIndexList objectAtIndex:i] intValue];
			CGRect frame = [[viewFrames objectAtIndex:viewFrameShiftIndex] CGRectValue];
			
			// Swap in the new frame
			UIView *v = [self.containerView viewWithTag:i];
			v.frame = frame;
			
		} // for ([self.containerView.subviews count])
		
		// Load the new data into the newly positioned view.
		if (self.contentOffsetFromCenter.x < 0.0) {
			
			EchoSequenceDataRangeView *src = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:0];
			EchoSequenceDataRangeView *dst = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:2];

			NSRange basepairSubrange = NSMakeRange((src.basepairSubrange.location - src.basepairSubrange.length) , src.basepairSubrange.length);
			[dst updateSequenceData:self.sequenceData basepairRange:self.basepairRange basepairSubrange:basepairSubrange];
			
			for (UIView *v in self.containerView.subviews) {
				
				int tag = (v.tag + 1) % [self.containerView.subviews count];
				
				v.tag = tag;
				
			} // for (self.containerView.subviews)
			
			
		} else {
			
			EchoSequenceDataRangeView *src = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:2];
			EchoSequenceDataRangeView *dst = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:0];
			
			NSRange basepairSubrange = NSMakeRange((src.basepairSubrange.location + src.basepairSubrange.length) , src.basepairSubrange.length);
			[dst updateSequenceData:self.sequenceData basepairRange:self.basepairRange basepairSubrange:basepairSubrange];

			for (UIView *v in self.containerView.subviews) {
				
				int tag = v.tag;
				--tag;
				
				// modulo operation when going negative. The % operator can't handle this
				if (tag < 0) {
					
					tag = [self.containerView.subviews count] - 1;
					
				} // if (tag < 0)
				
				v.tag = tag;
				
			} // for (self.containerView.subviews)
			
		}
		
	
		// Sanity check. Are the view tags updated properly.
		for (NSUInteger i = 0; i < [self.containerView.subviews count]; i++) {
			
			EchoSequenceDataRangeView *v = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:i];
			NSLog(@"%@", v);
			
		} // for (self.containerView.subviews)
		NSLog(@" ");
		
		self.doRecenterContentView = NO;
		
	} // if (self.doRecenterContentView == YES)

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	
	return self.containerView;
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//	NSLog(@"LazyLoadingScrollViewAppDelegate - scrollViewDidEndScrollingAnimation:");	
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

//
// This kills off auto-scrolling. Voila!
// See StackOverflow: http://bit.ly/1OpCeN
//
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	
	[scrollView setContentOffset:scrollView.contentOffset animated:YES];
	
}

#pragma mark -
#pragma mark LazyLoadingScrollViewAppDelegate Utility Methods

+ (UIColor *)colorWithIndex:(NSUInteger)index {
	
    if (LazyLoadingScrollViewAppDelegateColorList == nil) {
		
        LazyLoadingScrollViewAppDelegateColorList = [[NSArray alloc] 
													 initWithObjects:
													 [UIColor redColor], 
													 [UIColor greenColor], 
													 [UIColor magentaColor],
													 [UIColor blueColor], 
													 [UIColor orangeColor], 
													 [UIColor brownColor], 
													 [UIColor grayColor], 
													 nil];
    }
	
    return [LazyLoadingScrollViewAppDelegateColorList objectAtIndex:index % [LazyLoadingScrollViewAppDelegateColorList count]];
}

- (void)loadScrollViewFromPageSet:(NSMutableSet *)pageSet width:(float)width {
	
	for (NSNumber *n in pageSet) {
		
		CGFloat xOffset			= ((float) [n integerValue]) * width;
		CGRect frame			= CGRectMake(xOffset, 0, width, self.scrollView.bounds.size.height);
		
		EchoSequenceDataRangeView *v	= [[[EchoSequenceDataRangeView alloc] initWithFrame:frame] autorelease];
		v.tag							= [n integerValue];
		
		v.backgroundColor			= [LazyLoadingScrollViewAppDelegate colorWithIndex:[n integerValue]];
		
		[self.containerView addSubview:v];
		
	} // for (pageSet)
	
}

- (void)doBitBucket {
	
	NSLog(@"LazyLoadingScrollViewAppDelegate - doBitBucket");
	
	[self.spinner stopAnimating];

}

- (void)didFinishRetrievingSequenceData:(NSDictionary *)results {
	
	self.sequenceData		= [results objectForKey:@"sequenceData"];
	self.sequenceString		= [[[NSString alloc] initWithBytes:[self.sequenceData bytes] length:[self.sequenceData length] encoding:NSUTF8StringEncoding] autorelease];
	
	NSUInteger location	= [[results objectForKey:@"basepairStart"] intValue];
	NSUInteger length	= [[results objectForKey:@"basepairEnd"  ] intValue] - location;
	self.basepairRange	= NSMakeRange(location, length);
		
	NSUInteger i, start;
	for (i = 0, start = self.basepairRange.location; i < [self.containerView.subviews count]; i++, start += self.basepairPerView) {
				
		EchoSequenceDataRangeView *v = (EchoSequenceDataRangeView *)[self.containerView viewWithTag:i];
		
		NSRange basepairSubrange = NSMakeRange(start, self.basepairPerView);
		[v updateSequenceData:self.sequenceData basepairRange:self.basepairRange basepairSubrange:basepairSubrange];

//		[self updateDataInViews:v startBasepairValue:start];
		
	} // for ([self.containerView.subviews count])
	
	[self.spinner stopAnimating];
	
}

@end
