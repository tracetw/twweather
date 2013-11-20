#import "TWBasicViewController.h"
#import "TWWeatherAppDelegate.h"

@interface TWBasicViewController ()

@end

@implementation TWBasicViewController

- (id <GAITracker>)tracker
{
	return [TWWeatherAppDelegate sharedDelegate].tracker;
}

@end
