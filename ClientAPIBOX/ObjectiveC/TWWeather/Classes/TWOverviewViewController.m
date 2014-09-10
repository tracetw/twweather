//
// TWOverviewViewController.m
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

#import "TWOverviewViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWOverviewViewController
{
	UITextView *textView;
	NSString *_text;
}

#pragma mark UIViewContoller Methods

- (void)loadView
{
	UITextView *theTextView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	theTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	theTextView.editable = NO;
	theTextView.font = [UIFont systemFontOfSize:18.0];
	self.textView = theTextView;
	self.view = theTextView;
	if (![self.title length]) {
		self.title = @"關心天氣";
	}

	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.screenName = @"Overview";
	self.textView.text = _text;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)setText:(NSString *)text
{
	_text = text;
	self.textView.text = text;
}

- (IBAction)navBarAction:(id)sender
{
	NSString *feedTitle = [self title];
	NSString *description = [_text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, description];
	NSArray *activityItems = @[text];
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	[self presentViewController:activityController animated:YES completion:nil];
}

@synthesize textView;
@dynamic text;

@end
