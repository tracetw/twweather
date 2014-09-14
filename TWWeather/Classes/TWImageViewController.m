//
// TWImageViewController.m
//
// Copyright (c) Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TWImageViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWCommonHeader.h"

@implementation TWImageViewController
{
	UIImageView *_imageView;
	UIImage *_image;
	NSURL *_imageURL;

	TWLoadingView *loadingView;
	UIPopoverController *popoverController;
	BOOL pushingPlurkComposer;
}

#pragma mark UIViewContoller Methods

- (void)loadView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.backgroundColor = [UIColor blackColor];
	scrollView.canCancelContentTouches = NO;
	scrollView.clipsToBounds = YES;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.minimumZoomScale = 1;
	scrollView.maximumZoomScale = 2.5;
	scrollView.scrollEnabled = YES;
	scrollView.delegate = self;
	scrollView.userInteractionEnabled = YES;

	self.view = scrollView;

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imageView.backgroundColor = [UIColor blackColor];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView = imageView;
	[scrollView setContentSize:self.imageView.frame.size];
	[scrollView addSubview:imageView];

	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.imageView.image = self.image;
	[(UIScrollView *)self.view setContentSize:_imageView.frame.size];

	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark Getters/Setters

- (void)setImage:(UIImage *)image
{
	_image = image;
	self.imageView.image = image;
}
- (UIImage *)image
{
	return _image;
}

#pragma mark -
#pragma mark Actions

- (IBAction)navBarAction:(id)sender
{
	NSArray *activityItems = @[_image];
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	if (isIPad()) {
		if (!popoverController.popoverVisible) {
			popoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
			[popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		}
	}
	else {
		[self presentViewController:activityController animated:YES completion:nil];
	}
}

- (void)showLoadingView
{
	[self.view addSubview:loadingView];
	[loadingView startAnimating];
	self.view.userInteractionEnabled = NO;
}
- (void)hideLoadingView
{
	[loadingView stopAnimating];
	self.view.userInteractionEnabled = YES;
}

#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;
@dynamic image;

@end
