//
// TWSettingTableViewController.m
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

#import "TWSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWWeatherAppDelegate+BGM.h"
#import "TWCommonHeader.h"

@interface TWSettingTableViewController()
- (IBAction)toggleBGMSettingAction:(id)sender;
- (IBAction)toggleSFXSettingAction:(id)sender;
@end

@implementation TWSettingTableViewController
{
	UISwitch *BGMSwitch;
	UISwitch *SFXSwitch;
}

- (void)dealloc
{
	[BGMSwitch release];
	BGMSwitch = nil;
	[SFXSwitch release];
	SFXSwitch = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	[super viewDidLoad];

	if (!BGMSwitch) {
		BGMSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 8, 80, 40)];
		[BGMSwitch addTarget:self action:@selector(toggleBGMSettingAction:) forControlEvents:UIControlEventValueChanged];
		BGMSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:TWBGMPreference];
	}
	if (!SFXSwitch) {
		SFXSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 8, 80, 40)];
		[SFXSwitch addTarget:self action:@selector(toggleSFXSettingAction:) forControlEvents:UIControlEventValueChanged];
		SFXSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:TWSFXPreference];
	}
	self.title = NSLocalizedString(@"Settings", @"");
	self.screenName = @"Settings";
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark Actions

- (IBAction)toggleBGMSettingAction:(id)sender
{
	UISwitch *aSwitch = (UISwitch *)sender;
	if (aSwitch.on) {
		[[TWWeatherAppDelegate sharedDelegate] startPlayingBGM];
	}
	else {
		[[TWWeatherAppDelegate sharedDelegate] stopPlayingBGM];
	}
	[[NSUserDefaults standardUserDefaults] setBool:aSwitch.on forKey:TWBGMPreference];
}
- (IBAction)toggleSFXSettingAction:(id)sender
{
	UISwitch *aSwitch = (UISwitch *)sender;
	[[NSUserDefaults standardUserDefaults] setBool:aSwitch.on forKey:TWSFXPreference];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.accessoryView = nil;
	if (indexPath.section == 0) {
		cell.imageView.image = nil;
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = NSLocalizedString(@"BGM", @"");
				cell.accessoryView = BGMSwitch;
				break;
			case 1:
				cell.textLabel.text = NSLocalizedString(@"SFX", @"");
				cell.accessoryView = SFXSwitch;
				break;
			default:
				break;
		}
	}
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return NSLocalizedString(@"Basic Settings", @"");
}

@end
