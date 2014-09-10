//
// TWWeatherAppDelegate.m
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

#import "TWWeatherAppDelegate.h"
#import "TWWeatherAppDelegate+BGM.h"
#import "TWRootViewController.h"
#import "TWMoreViewController.h"
#import "TWFavoriteTableViewController.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWCommonHeader.h"

@implementation TWWeatherAppDelegate

+ (TWWeatherAppDelegate*)sharedDelegate
{
	return (TWWeatherAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

	audioPlayer = nil;
	window.backgroundColor = [UIColor blackColor];
	if ([window respondsToSelector:@selector(setTintColor:)]) {
		[window setTintColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
		[window setBackgroundColor:[UIColor clearColor]];
	}

	UITabBarController *controller = [[UITabBarController alloc] init];

	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *loaclizedDictionary = [bundle localizedInfoDictionary];
	controller.title = loaclizedDictionary[@"CFBundleDisplayName"];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL];
	controller.navigationItem.backBarButtonItem = item;

	self.tabBarController = controller;

	NSMutableArray *controllerArray = [NSMutableArray array];

	TWFavoriteTableViewController *favController = [[TWFavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	favController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
	[favController view];
	[controllerArray addObject:favController];

	TWRootViewController *rootController = [[TWRootViewController alloc] initWithStyle:UITableViewStylePlain];
	rootController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Forecasts", @"") image:[UIImage imageNamed:@"forecasts.png"] tag:1];
	[controllerArray addObject:rootController];

	TWMoreViewController *moreController = [[TWMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
	moreController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
	[controllerArray addObject:moreController];

	UINavigationController *mainNavigationController = [[TWNavigationController alloc] initWithRootViewController:self.tabBarController];
	self.navigationController = [[TWNavigationController alloc] initWithRootViewController:tabBarController];

	if ([[UIDevice currentDevice].systemVersion intValue] > 8) {
		splitViewController = [[UISplitViewController alloc] init];
		splitViewController.viewControllers = @[mainNavigationController];
		splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
	}

	if ([[NSUserDefaults standardUserDefaults] boolForKey:TWBGMPreference]) {
		[self startPlayingBGM];
	}

	[GAI sharedInstance].trackUncaughtExceptions = YES;
	[GAI sharedInstance].dispatchInterval = 20;
#if DEBUG
	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#endif
	tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-144934-10"];

	if ([[UIDevice currentDevice].systemVersion intValue] > 8) {
		window.rootViewController = splitViewController;
	}
	else {
		window.rootViewController = self.navigationController;
	}
	window.backgroundColor = [UIColor clearColor];
	[window makeKeyAndVisible];

	self.tabBarController.viewControllers = controllerArray;
	return YES;
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
	if ([[UIDevice currentDevice].systemVersion intValue] > 8) {
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
		[splitViewController showDetailViewController:navController sender:nil];
		return;
	}
	[self.navigationController pushViewController:controller animated:animated];
}

- (NSString *)imageNameWithTimeTitle:(NSString *)timeTitle description:(NSString *)description
{
	NSMutableString *string = [NSMutableString string];

	if ([@[@"今晚至明晨", @"今晚明晨", @"明晚後天"] containsObject: timeTitle]) {
		[string setString:@"Night"];
	}
	else {
		[string setString:@"Day"];
	}

	NSDictionary *map = @{
	  @"晴時多雲": @"SunnyCloudy",
	  @"多雲時晴": @"CloudySunny",
	  @"多雲時陰": @"CloudyGlommy",
	  @"多雲短暫雨": @"GloomyRainy",
	  @"多雲": @"Cloudy",
	  @"陰天": @"Glommy",
	  @"陰": @"Glommy",
	  @"晴天": @"Sunny",
	  @"晴": @"Sunny"};

	BOOL found = NO;
	for (NSString *key in [map allKeys]) {
		if ([description hasPrefix:key]) {
			found = YES;
			[string appendString:map[key]];
			break;
		}
	}
	if (!found) {
		[string appendString:@"Rainy"];
	}

	[string appendString:@".png"];
	return string;
}

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize tracker;

@end
