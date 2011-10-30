#import "UIViewController+Compatibility.h"

@implementation UIViewController (Compatibility)

- (UIViewController *)compitibaleParentViewController
{
	if ([self respondsToSelector:@selector(presentingViewController)]) {
		return [self performSelector:@selector(presentingViewController)];		
	}
	return [self parentViewController];
}

@end
