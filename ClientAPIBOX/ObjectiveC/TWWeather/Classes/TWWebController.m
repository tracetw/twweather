//
// TWWebController.m
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

#import "TWWebController.h"

@interface TWWebController()
- (IBAction)openInExternalWebBrowser:(id)sender;
- (void)openInExternalWebBrowser;
- (void)updateButtonState;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *goBackItem;
@property (strong, nonatomic) UIBarButtonItem *goFowardItem;
@property (strong, nonatomic) UIBarButtonItem *stopItem;
@property (strong, nonatomic) UIBarButtonItem *reloadItem;
@end

@implementation TWWebController
{
	UIWebView *webView;
	UIActivityIndicatorView *activityIndicatorView;
	UIBarButtonItem *goBackItem;
	UIBarButtonItem *goFowardItem;
	UIBarButtonItem *stopItem;
	UIBarButtonItem *reloadItem;
	UIToolbar *toolbar;
}

#pragma mark Routines

- (void)removeOutletsAndControls_TWWebController
{
	[self.webView stopLoading];
	self.webView = nil;
	self.activityIndicatorView = nil;
	self.toolbar = nil;
	self.goBackItem = nil;
	self.goFowardItem = nil;
	self.stopItem = nil;
	self.reloadItem = nil;
}

- (void)dealloc
{
	[self removeOutletsAndControls_TWWebController];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWWebController];
}

#pragma mark -
#pragma mark UIViewContoller Methods

- (void)loadView
{
	UIView *aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	aView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view = aView;

	CGRect webFrame = self.view.bounds;
	webFrame.size.height -= 44.0;
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];

	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44.0, self.view.bounds.size.width, 44.0)];
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[self.view addSubview:toolbar];

#define SPACE [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL]
	goBackItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webBack"] style:UIBarButtonItemStylePlain target:webView action:@selector(goBack)];
	goFowardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webForward"] style:UIBarButtonItemStylePlain target:webView action:@selector(goForward)];
	stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:webView action:@selector(stopLoading)];
	reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:webView action:@selector(reload)];
	activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	toolbar.items = @[SPACE, goBackItem, SPACE, goFowardItem, SPACE, stopItem, SPACE, reloadItem, SPACE];
#undef SPACE
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.screenName = @"Web";

	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	self.navigationItem.rightBarButtonItem = item;
	activityIndicatorView.hidesWhenStopped = YES;
	[webView setDelegate:self];
	[self updateButtonState];
}

#pragma mark Actions

- (void)openInExternalWebBrowser
{
	NSURL *URL = [webView.request URL];
	[[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)openInExternalWebBrowser:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open in Safari", @""), nil];
	[actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self openInExternalWebBrowser];
	}
}

#pragma mark -
#pragma mark WebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndicatorView startAnimating];
	[self updateButtonState];
	[reloadItem setEnabled:NO];
	[stopItem setEnabled:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if ([error code] == -999) {
		return;
	}

	[activityIndicatorView startAnimating];
	[self updateButtonState];
	[reloadItem setEnabled:YES];
	[stopItem setEnabled:NO];

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to open web page.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];

	[activityIndicatorView stopAnimating];
	[self updateButtonState];
	[reloadItem setEnabled:YES];
	[stopItem setEnabled:NO];
}

- (void)updateButtonState
{
	[goBackItem setEnabled:[webView canGoBack]];
	[goFowardItem setEnabled:[webView canGoForward]];
}

@synthesize webView;
@synthesize activityIndicatorView;
@synthesize toolbar;
@synthesize goBackItem;
@synthesize goFowardItem;
@synthesize stopItem;
@synthesize reloadItem;

@end
