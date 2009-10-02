//
//  ConstrainedView.m
//  HelloScroll
//
//  Created by turner on 9/14/09.
//  Copyright 2009 Douglass Turner Consulting. All rights reserved.
//

#import "ConstrainedView.h"

@implementation ConstrainedView

- (void)dealloc {
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        // Initialization code
    }
	
    return self;
}

/*
 
 See iPhone Reference Library "CGAffineTransform Reference ": http://bit.ly/1Po2YT
 
struct CGAffineTransform {
	CGFloat a;
	CGFloat b;
	CGFloat c;
	CGFloat d;
	CGFloat tx;
	CGFloat ty;
};
 
 a  c  tx
 b  d  ty
 0  0  1 
 
*/

- (CGAffineTransform)transform {
	
	return [super transform];
	
}

- (void)setTransform:(CGAffineTransform)newValue {
	
//	NSLog(@" SELF BEFORE:");
//	NSLog(@"%f %f %f", self.transform.a, self.transform.c, self.transform.tx);
//	NSLog(@"%f %f %f", self.transform.b, self.transform.d, self.transform.ty);
//	NSLog(@"%f %f %f", 0.0, 0.0, 1.0);

//	NSLog(@" IN:");
//	NSLog(@"%f %f %f", newValue.a, newValue.c, newValue.tx);
//	NSLog(@"%f %f %f", newValue.b, newValue.d, newValue.ty);
//	NSLog(@"%f %f %f", 0.0, 0.0, 1.0);

	

	
	// Scale along the x-axis only
	CGAffineTransform constrainedTransform = CGAffineTransformScale(CGAffineTransformIdentity, newValue.a, 1.0);
	newValue.a = constrainedTransform.a;
	newValue.b = constrainedTransform.b;
	newValue.c = constrainedTransform.c;
	newValue.d = constrainedTransform.d;

	
	
//	NSLog(@"OUT:");
//	NSLog(@"%f %f %f", newValue.a, newValue.c, newValue.tx);
//	NSLog(@"%f %f %f", newValue.b, newValue.d, newValue.ty);
//	NSLog(@"%f %f %f", 0.0, 0.0, 1.0);
	
	[super setTransform:newValue];	
	
//	NSLog(@" SELF AFTER:");
//	NSLog(@"%f %f %f", self.transform.a, self.transform.c, self.transform.tx);
//	NSLog(@"%f %f %f", self.transform.b, self.transform.d, self.transform.ty);
//	NSLog(@"%f %f %f", 0.0, 0.0, 1.0);
	
}

@end
