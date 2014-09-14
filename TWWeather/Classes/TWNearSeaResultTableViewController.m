//
// TWNearSeaResultViewController.m
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

#import "TWNearSeaResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWNearSeaCell.h"
#import "TWCommonHeader.h"

@implementation TWNearSeaResultTableViewController
{
	NSString *description;;
	NSString *publishTime;
	NSString *validBeginTime;
	NSString *validEndTime;
	NSString *wave;
	NSString *waveLevel;
	NSString *wind;
	NSString *windScale;

	UIPopoverController *popoverController;
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;

	self.screenName = @"Near Sea Details";
}

#pragma mark -

- (NSString *)_feedDescription
{
	NSMutableString *attachmentDescription = [NSMutableString string];
	[attachmentDescription appendFormat:@"※ %@ - %@ ", self.validBeginTime, self.validEndTime];
	[attachmentDescription appendFormat:@"%@ ", self.description];
	[attachmentDescription appendFormat:@"%@ ", self.wave];
	[attachmentDescription appendFormat:@"%@ ", self.waveLevel];
	[attachmentDescription appendFormat:@"%@ ", self.wind];
	[attachmentDescription appendFormat:@"%@ ", self.windScale];
	return attachmentDescription;
}

- (IBAction)navBarAction:(id)sender
{
	NSString *feedTitle = [NSString stringWithFormat:@"%@ 天氣預報", [self title]];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, [self _feedDescription]];
	NSArray *activityItems = @[text];
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

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";

	TWNearSeaCell *cell = (TWNearSeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[TWNearSeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.description = self.description;
	cell.validBeginTime = self.validBeginTime;
	cell.validEndTime = self.validEndTime;
	cell.wave = self.wave;
	cell.waveLevel = self.waveLevel;
	cell.wind = self.wind;
	cell.windScale = self.windScale;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:@"" description:cell.description ];
	cell.imageView.image = [UIImage imageNamed:imageString];

	[cell setNeedsDisplay];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 320.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize description;
@synthesize publishTime;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windScale;

@end
