//
// TWMoreViewController.m
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

#import "TWMoreViewController.h"
#import "TWSettingTableViewController.h"
#import "TWAboutViewController.h"
#import "TWWebController.h"
#import "TWWeatherAppDelegate.h"

@interface TWMoreViewController()
- (IBAction)sendEmailAction:(id)sender;
@end

@implementation TWMoreViewController

- (void)sendEmailAction:(id)sender
{
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject:NSLocalizedString(@"TW Weather Questions/Inquiry", @"")];
		[controller setToRecipients:@[@"Weizhong Yang<service@zonble.net>"]];
		[self presentViewController:controller animated:YES completion:nil];
	}
	else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You cannot send email now",@"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alertView show];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.screenName = @"More";
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
		self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 4;
	}
	else if (section == 1) {
		return 3;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *NormalIdentifier = @"NormalCell";

	if (indexPath.section == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalIdentifier];
		}
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.imageView.image = nil;
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"中央氣象局網頁";
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			case 1:
				cell.textLabel.text = @"中央氣象局網頁 PDA 版";
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			case 2:
				cell.textLabel.text = @"氣象查詢：886-2-23491234";
				cell.imageView.image = [UIImage imageNamed:@"tel.png"];
				break;
			case 3:
				cell.textLabel.text = @"地震查詢：886-2-23491168";
				cell.imageView.image = [UIImage imageNamed:@"tel.png"];
				break;
			default:
				break;
		}
		return cell;
	}
	else if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalIdentifier];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.imageView.image = nil;
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = NSLocalizedString(@"Settings", @"");
				break;
			case 1:
				cell.textLabel.text = NSLocalizedString(@"About", @"");
				break;
			case 2:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = NSLocalizedString(@"Feedback", @"");
				break;
			default:
				break;
		}
		return cell;
	}

	return nil;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		if (indexPath.row < 2) {
			TWWebController *webController = [[TWWebController alloc] initWithNibName:@"TWWebController" bundle:[NSBundle mainBundle]];
			[[TWWeatherAppDelegate sharedDelegate] pushViewController:webController animated:YES];
			if (indexPath.row == 0) {
				webController.title = @"中央氣象局網頁";
				[webController view];
				[webController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cwb.gov.tw/"]]];
			}
			else if (indexPath.row == 1) {
				webController.title = @"中央氣象局網頁 PDA 版";
				[webController view];
				webController.webView.scalesPageToFit = NO;
				[webController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cwb.gov.tw/pda/"]]];
			}
			return;
		}

		NSString *model = [UIDevice currentDevice].model;
		if (![model isEqualToString:@"iPhone"]) {
			NSString *title = [NSString stringWithFormat:NSLocalizedString(@"You can not make a phone call with an %@", @""), model];
			UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"Your device does not supprt to make a phone call, please use a telephone or cellphone to dial the number.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
			[alertview show];
		}

		NSString *URLString = nil;
		if (indexPath.row == 2) {
			URLString = @"tel://+886223491234";
		}
		else if (indexPath.row == 3) {
			URLString = @"tel://+886223491168";
		}
		if (URLString) {
			NSURL *URL = [NSURL URLWithString:URLString];
			[[UIApplication sharedApplication] openURL:URL];
		}

	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 2) {
			[self sendEmailAction:self];
			return;
		}

		UIViewController *controller = nil;
		if (indexPath.row == 0) {
			controller = [[TWSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		}
		else if (indexPath.row == 1) {
			controller = [[TWAboutViewController alloc] init];
		}
		if (controller) {
			[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
		}
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

#pragma mark -

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	UIViewController *parentController = [controller presentingViewController];
	[parentController dismissViewControllerAnimated:YES completion:nil];
	if (result == MFMailComposeResultSent) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your mail is sent!", @"") message:NSLocalizedString(@"Thanks for your feedback.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alertView show];
	}
}

@end
