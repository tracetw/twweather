//
// TWLocationAddTableViewController.m
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

#import "TWLocationAddTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWLocationAddTableViewController()
- (IBAction)cancelAction:(id)sender;
@property (strong, nonatomic) NSArray *contentArray;
@end

@implementation TWLocationAddTableViewController
{
	id <TWLocationAddTableViewControllerDelegate> __weak delegate;
	NSArray *contentArray;
}

#pragma mark Routines


#pragma mark -
#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	self.navigationItem.leftBarButtonItem = cancelItem;
}
- (IBAction)cancelAction:(id)sender
{
	[[self.navigationController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateContentArrayWithFilterArray:(NSArray *)filterArray
{
	NSMutableArray *array = [NSMutableArray array];
	NSArray *locations = [[TWAPIBox sharedBox] forecastLocations];
	for (NSUInteger i = 0; i < [locations count]; i++) {
		if (![filterArray containsObject:@(i)]) {
			NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:locations[i]];
			d[@"filterID"] = @(i);
			[array addObject:d];
		}
	}
	self.contentArray = array;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableView view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [contentArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	NSDictionary *d = contentArray[indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.textLabel.text = name;
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (delegate && [delegate respondsToSelector:@selector(locationAddTableViewController:didSelectedLocationIdentifier:)]) {
		NSUInteger filterID = [(self.contentArray)[indexPath.row][@"filterID"] intValue];
		[delegate locationAddTableViewController:self didSelectedLocationIdentifier:filterID];
		[[self.navigationController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
	}
}

@synthesize delegate;
@synthesize contentArray;

@end

