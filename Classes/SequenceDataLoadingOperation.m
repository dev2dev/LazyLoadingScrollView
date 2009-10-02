//
//  SequenceDataLoadingOperation.m
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright 2009 Douglass Turner Consulting. All rights reserved.
//

#import "SequenceDataLoadingOperation.h"

@implementation SequenceDataLoadingOperation

- (void)dealloc {
	
    [_requestPackage	release];
    [super				dealloc];
}

- (id)initWithSequenceDataRequestPackage:(NSDictionary *)requestPackage target:(id)target action:(SEL)action {
	
    self = [super init];
	
    if (self) {
		
        _requestPackage	= [requestPackage retain];		
        _target			= target;
        _action			= action;
    }
	
    return self;
}

- (void)main {
	
	NSString *genome		= @"hg18";
	
	NSString *basURLString	= @"http://www.broadinstitute.org/igv/sequence";
	
	NSString *chromosome		= [_requestPackage objectForKey:@"chromosome"];
	NSUInteger basepairStart	= [[_requestPackage objectForKey:@"basepairStart"] intValue];
	NSUInteger basepairEnd		= [[_requestPackage objectForKey:@"basepairEnd"]   intValue];
	
	NSString *concatenatedURLString = 
	[basURLString stringByAppendingFormat:@"/%@?chr=chr%@&start=%d&end=%d", genome, chromosome, basepairStart, basepairEnd];	

	NSURL *sequenceDataURL = [NSURL URLWithString:concatenatedURLString];
	
	NSMutableData *mutableData = [[[NSMutableData alloc] initWithContentsOfURL:sequenceDataURL] autorelease];

	NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
							chromosome,								@"chromosome",
							[NSNumber numberWithInt:basepairStart], @"basepairStart", 
							[NSNumber numberWithInt:basepairEnd],	@"basepairEnd", 
							mutableData,							@"sequenceData", 
							nil];
	
	[_target performSelectorOnMainThread:_action withObject:result waitUntilDone:NO];
   
}

@end
