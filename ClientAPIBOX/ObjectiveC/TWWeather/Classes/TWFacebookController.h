#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface TWFacebookController : UITableViewController <FBRequestDelegate>
{
	NSMutableArray *posts;
}

@end
