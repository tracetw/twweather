//
// TWAboutViewController.m
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

#import "TWAboutViewController.h"

@implementation TWAboutViewController
{
	UILabel *titleLabel;
	UILabel *copyrightLabel;
	UILabel *externalLibraryLabel;
}

- (void)dealloc
{
	self.view = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.backgroundColor = [UIColor whiteColor];
	scrollView.scrollEnabled = YES;
	self.view = scrollView;

	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	contentView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:contentView];
	scrollView.contentSize = contentView.frame.size;

	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *loaclizedDictionary = [bundle localizedInfoDictionary];
	NSDictionary *infoDictionary = [bundle infoDictionary];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.text = loaclizedDictionary[@"CFBundleDisplayName"];
	self.titleLabel = label;
	[contentView addSubview:self.titleLabel];

	label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 60)];
	label.font = [UIFont systemFontOfSize:14.0];
	label.numberOfLines = 3;
	label.text = [NSString stringWithFormat:NSLocalizedString(@"Version: %@\n%@", @""), infoDictionary[@"CFBundleVersion"], loaclizedDictionary[@"NSHumanReadableCopyright"]];
	self.copyrightLabel = label;
	[contentView addSubview:self.copyrightLabel];

	label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 300)];
	label.font = [UIFont systemFontOfSize:12.0];
	label.numberOfLines = 100;
	NSMutableString *text = [NSMutableString stringWithString:NSLocalizedString(@"Data comes from Central Weather Bureau\n\n", @"")];
	[text appendString:[NSString stringWithFormat:NSLocalizedString(@"%@ copyright ifno" , @""), loaclizedDictionary[@"CFBundleDisplayName"]]];
	label.text = text;
	self.externalLibraryLabel = label;
	[contentView addSubview:self.externalLibraryLabel];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"About", @"");
	self.screenName = @"About";
}

@synthesize titleLabel;
@synthesize copyrightLabel;
@synthesize externalLibraryLabel;

@end
