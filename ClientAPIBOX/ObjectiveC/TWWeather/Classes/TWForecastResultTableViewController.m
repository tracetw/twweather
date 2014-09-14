//
// TWForecastResultTableViewController.m
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

#import "TWForecastResultTableViewController.h"
#import "TWForecastResultCell.h"
#import "TWWeekResultTableViewController.h"
#import "TWErrorViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWLoadingCell.h"
#import "TWCommonHeader.h"
#import "TWAPIBox.h"

@interface TWForecastResultTableViewController()
- (IBAction)navBarAction:(id)sender;
- (void)pushWeekViewController;
@end

@implementation TWForecastResultTableViewController
{
	NSArray *forecastArray;
	NSString *weekLocation;
	NSDictionary *weekDictionary;

	BOOL isLoadingWeek;

	UIPopoverController *popoverController;
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	self.screenName = @"48 Hours Details";
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[TWAPIBox sharedBox] cancelAllRequestWithDelegate:self];
}
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (NSString *)_feedDescription
{
	NSMutableString *description = [NSMutableString string];
	for (NSDictionary *forecast in forecastArray) {
		[description appendFormat:@"※ %@", forecast[@"title"]];
		[description appendFormat:@"(%@ - %@) ", forecast[@"beginTime"], forecast[@"endTime"]];
		[description appendFormat:@"%@ ", forecast[@"description"]];
		[description appendFormat:@"降雨機率：%@ ", forecast[@"rain"]];
		[description appendFormat:@"氣溫：%@ ", forecast[@"temperature"]];
	}
	return description;
}

- (IBAction)navBarAction:(id)sender
{
	NSString *feedTitle = [NSString stringWithFormat:@"%@ 四十八小時天氣預報", [self title]];
	NSString *description = [self _feedDescription];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, description];
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

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (weekLocation) {
		return 2;
	}
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [forecastArray count];
	}
	else if (section == 1) {
		return 1;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	static NSString *NormalIdentifier = @"NormalCell";
	if (indexPath.section == 0) {
		TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dictionary = forecastArray[indexPath.row];
		cell.title = dictionary[@"title"];
		cell.description = dictionary[@"description"];
		cell.rain = dictionary[@"rain"];
		cell.temperature = dictionary[@"temperature"];
		NSString *beginTimeString = dictionary[@"beginTime"];
		NSDate *beginDate = [[TWAPIBox sharedBox] dateFromString:beginTimeString];
		cell.beginTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:beginDate];
		NSString *endTimeString = dictionary[@"endTime"];
		NSDate *endDate = [[TWAPIBox sharedBox] dateFromString:endTimeString];
		cell.endTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:endDate];

		NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:cell.title description:cell.description ];
		cell.weatherImage = [UIImage imageNamed:imageString];

		[cell setNeedsDisplay];
		return cell;
	}
	else if (indexPath.section == 1) {
		TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:NormalIdentifier];
		if (cell == nil) {
			cell = [[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalIdentifier];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"一週預報";

		if (isLoadingWeek) {
			[cell startAnimating];
		}
		else {
			[cell stopAnimating];
		}

		return cell;
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 112.0;
	}
	return 40.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		if (weekDictionary) {
			[self pushWeekViewController];
			return;
		}
		isLoadingWeek = YES;
		[self.tableView reloadData];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:self.weekLocation delegate:self userInfo:nil];
	}
}

#pragma mark -
#pragma mark TWWeatherAPI delegate

- (void)pushWeekViewController
{
	TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = (self.weekDictionary)[@"locationName"];
	controller.forecastArray = (self.weekDictionary)[@"items"];
	NSString *dateString = (self.weekDictionary)[@"publishTime"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromString:dateString];
	controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
	[self.navigationController pushViewController:controller animated:YES];
}
- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	if ([result isKindOfClass:[NSDictionary class]]) {
		self.weekDictionary = result;
		[self pushWeekViewController];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	[self pushErrorViewWithError:error];
}


@synthesize forecastArray;
@synthesize weekLocation;
@synthesize weekDictionary;

@end
