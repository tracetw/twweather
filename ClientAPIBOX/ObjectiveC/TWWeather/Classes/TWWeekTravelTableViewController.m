//
// TWWeekTravelTableViewController.m
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

#import "TWWeekTravelTableViewController.h"
#import "TWWeekResultTableViewController.h"

@implementation TWWeekTravelTableViewController

#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.array = [[TWAPIBox sharedBox] weekTravelLocations];
	self.title = @"一週旅遊天氣預報";
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableDictionary *dictionary = [self arrayForTableView:tableView][indexPath.row];
	tableView.userInteractionEnabled = NO;
	dictionary[@"isLoading"] = @YES;
	[tableView reloadData];

	NSString *identifier = dictionary[@"identifier"];
	[[TWAPIBox sharedBox] fetchWeekTravelWithLocationIdentifier:identifier delegate:self userInfo:dictionary];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeekTravel:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	if ([result isKindOfClass:[NSDictionary class]]) {
		TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.title = result[@"locationName"];
		controller.forecastArray = result[@"items"];
		NSString *dateString = result[@"publishTime"];
		NSDate *date = [[TWAPIBox sharedBox] dateFromString:dateString];
		controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekTravelWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	[self pushErrorViewWithError:error];
}

@end

