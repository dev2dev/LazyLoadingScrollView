//
//  EchoSequenceDataRangeView.m
//  LazyLoadingScrollView
//
//  Created by turner on 10/4/09.
//  Copyright 2009 Douglass Turner Consulting. All rights reserved.
//

#import "EchoSequenceDataRangeView.h"

@implementation EchoSequenceDataRangeView

@synthesize basepairSubrange=_basepairSubrange;
@synthesize basepairRange=_basepairRange;

- (void)dealloc {
	
	[_sequenceDataSubrange			release];
	[_sequenceDataSubrangeString	release];

    [super							dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ tag: %d basepairRange: %d %d basepairSubRange: %d %d", 
			[self class],
			self.tag, 
			self.basepairRange.location, self.basepairRange.length, self.basepairSubrange.location, self.basepairSubrange.length];
}

- (NSData *)sequenceDataSubrange {
	
	return _sequenceDataSubrange;
	
}

- (void)setSequenceDataSubrange:(NSData *)value {
	
	if (_sequenceDataSubrange != value) {
		
		[_sequenceDataSubrange release];
		_sequenceDataSubrange = [value retain];
		
	}
	
}

- (NSString *)sequenceDataSubrangeString {
	
	return _sequenceDataSubrangeString;
	
}

- (void)setSequenceDataSubrangeString:(NSString *)value {
	
	if (_sequenceDataSubrangeString != value) {
		
		[_sequenceDataSubrangeString release];
		_sequenceDataSubrangeString = [value retain];
		
	}
	
}

- (void)updateSequenceData:(NSData *)sequenceData basepairRange:(NSRange)basepairRange basepairSubrange:(NSRange)basepairSubrange {

	self.basepairRange		= basepairRange;
	self.basepairSubrange	= basepairSubrange;

	NSRange subdataRange = NSMakeRange((self.basepairSubrange.location - self.basepairRange.location), self.basepairSubrange.length);
	
	NSLog(@"%@ subdataRange: %d %d", self, subdataRange.location, subdataRange.length);
	
	NSData* d = [[sequenceData subdataWithRange:subdataRange] retain];

	[self setSequenceDataSubrange:d];
	[d release];
	
	
	NSString *str = 
	[[NSString alloc] initWithBytes:[self.sequenceDataSubrange bytes] length:[self.sequenceDataSubrange length] encoding:NSUTF8StringEncoding];
	
	[self setSequenceDataSubrangeString:str];
	[str release];

	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        // Initialization code
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

	CGFloat fontSize = 32.0;

	[[UIColor whiteColor] setFill];
	NSString *startString = [NSString stringWithFormat:@"%d", self.basepairSubrange.location];	
	CGSize startStringBBox = [startString sizeWithFont:[UIFont systemFontOfSize:fontSize]];
	[startString drawAtPoint:CGPointMake(center.x - startStringBBox.width/2, (center.y - center.y/4) - startStringBBox.height/2) withFont:[UIFont systemFontOfSize:fontSize]];
	
	NSString   *endString = [NSString stringWithFormat:@"%d", (self.basepairSubrange.location + self.basepairSubrange.length -1)];
	CGSize endStringBBox = [endString sizeWithFont:[UIFont systemFontOfSize:fontSize]];
	[endString   drawAtPoint:CGPointMake(center.x -   endStringBBox.width/2, (center.y + center.y/4) -   endStringBBox.height/2) withFont:[UIFont systemFontOfSize:fontSize]];
	
//	[[UIColor whiteColor] setFill];
//	NSString *tagString = [NSString stringWithFormat:@"%d", self.tag];	
//	CGSize tagStringBBox = [tagString sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//	[tagString drawAtPoint:CGPointMake(center.x - tagStringBBox.width/2, center.y - tagStringBBox.height/2) withFont:[UIFont systemFontOfSize:fontSize]];

}

@end
