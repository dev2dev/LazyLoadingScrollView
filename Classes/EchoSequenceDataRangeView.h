//
//  EchoSequenceDataRangeView.h
//  LazyLoadingScrollView
//
//  Created by turner on 10/4/09.
//  Copyright 2009 Douglass Turner Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EchoSequenceDataRangeView : UIView {

	NSRange		_basepairSubrange;
	NSRange		_basepairRange;
	
	NSData		*_sequenceDataSubrange;
	NSString	*_sequenceDataSubrangeString;

}

@property(nonatomic) NSRange			basepairSubrange;
@property(nonatomic) NSRange			basepairRange;

- (NSData *)sequenceDataSubrange;
- (void)setSequenceDataSubrange:(NSData *)value;

- (NSString *)sequenceDataSubrangeString;
- (void)setSequenceDataSubrangeString:(NSString *)value;

- (void)updateSequenceData:(NSData *)sequenceData basepairRange:(NSRange)basepairRange basepairSubrange:(NSRange)basepairSubrange;

@end
