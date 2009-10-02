//
//  LazyLoadingScrollViewAppDelegate.h
//  LazyLoadingScrollView
//
//  Created by turner on 10/2/09.
//  Copyright Douglass Turner Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyLoadingScrollViewAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *viewControllers;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@end

