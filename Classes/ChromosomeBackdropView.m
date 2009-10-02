//
//  ChromosomeBackdropView.m
//  HelloSequence
//
//  Created by turner on 9/27/09.
//  Copyright 2009 Douglass Turner Consulting. All rights reserved.
//

#import "ChromosomeBackdropView.h"

@implementation ChromosomeBackdropView

- (void)dealloc {
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        // Initialization code
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	NSLog(@"ChromosomeBackdropView - drawRect - tag: %d", self.tag);
	
	int i;
	float exe;
	float tileWidth = 8.0;
	
	for (i = 0, exe = self.bounds.origin.x; i < self.bounds.size.width; i++, exe += 1.0) {
		
		if (i % ((NSUInteger) tileWidth) == 0) {
			
			CGRect candidate = CGRectMake(exe, self.bounds.origin.y, exe + tileWidth, self.bounds.size.height);
			CGRect tile = CGRectIntersection(candidate, self.bounds);
			
			// Paint the view background a random color
			int zeroTo255;
			float r, g, b;
			
			if (self.tag % 2 == 0) {
				
				zeroTo255 = (arc4random() % 255) + 1;
				r = ((float)zeroTo255) / 255.0;
				
				g = b = 0.0;
				
			} else {
				
				zeroTo255 = (arc4random() % 255) + 1;
				g = ((float)zeroTo255) / 255.0;
				
				r = b = 0.0;
				
			}
			
			[[UIColor colorWithRed:r green:g blue:b alpha:1.0] setFill];
			UIRectFill(tile);

		} // if (i % 16 == 0)
			
	} // for (self.bounds.size.width)
	
}

@end
