#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController {
	
    IBOutlet UILabel *pageNumberLabel;
    int pageNumber;
}

@property (nonatomic, retain) UILabel *pageNumberLabel;

- (id)initWithPageNumber:(int)page;

@end
