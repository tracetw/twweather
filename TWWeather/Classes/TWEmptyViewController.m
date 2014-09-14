#import "TWEmptyViewController.h"

@interface TWEmptyViewController ()

@end

@implementation TWEmptyViewController

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
