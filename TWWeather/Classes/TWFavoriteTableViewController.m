//
// TWFavoriteTableViewController.m
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

#import "TWFavoriteTableViewController.h"
#import "TWForecastResultTableViewController.h"
#import "TWOverviewViewController.h"
#import "TWErrorViewController.h"
#import "TWWeekResultTableViewController.h"
#import "TWWebController.h"
#import "TWForecastResultCell.h"
#import "TWFavoriteSectionCell.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

static NSString *lastAllForecastsPreferenceName = @"myLastAllForecastsPreferenceName";
static NSString *favoitesPreferenceName = @"myFavoitesPreferenceName";

@interface TWFavoriteTableViewController()
- (void)updateFilteredArray;
- (void)loadData;
- (void)showLoadingView;
- (void)hideLoadingView;

- (IBAction)changeSetting:(id)sender;
- (IBAction)reload:(id)sender;

@property (strong, nonatomic) NSDate *updateDate;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation TWFavoriteTableViewController
{
	NSMutableArray *_filterArray;
	NSMutableArray *_filteredArray;
	NSMutableArray *_favArray;
	NSMutableArray *warningArray;
	NSMutableDictionary *weekDictionary;
	NSDate *updateDate;

	TWLoadingView *loadingView;
	UITableView *_tableView;
	UILabel *errorLabel;

	BOOL dataLoaded;
	BOOL isLoading;
	BOOL isLoadingWeek;
	NSUInteger loadingWeekIndex;
}

#pragma mark UIViewContoller Methods

- (void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	self.view = view;

	errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
	errorLabel.textAlignment = NSTextAlignmentCenter;
	errorLabel.numberOfLines = 10;
	errorLabel.font = [UIFont boldSystemFontOfSize:18.0];
	errorLabel.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	errorLabel.shadowColor = [UIColor whiteColor];
	errorLabel.shadowOffset = CGSizeMake(0, 2);
	[self.view addSubview:errorLabel];

	UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	aTableView.delegate = self;
	aTableView.dataSource = self;
	self.tableView = aTableView;
	[self.view addSubview:self.tableView];

	CGFloat w = (CGRectGetWidth(self.tableView.bounds) - 120) / 2;
	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(w, 120, 120, 120)];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.screenName = @"My Favorites";
	self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);

	_favArray = [[NSMutableArray alloc] init];
	NSArray *savedResult = [[NSUserDefaults standardUserDefaults] objectForKey:lastAllForecastsPreferenceName];
	if (savedResult) {
		[_favArray setArray:savedResult];
	}

	_filterArray = [[NSMutableArray alloc] init];
	NSArray *favoitesSetting = [[NSUserDefaults standardUserDefaults] objectForKey:favoitesPreferenceName];
	if (!favoitesSetting) {
		favoitesSetting = @[@0, @1];
		[[NSUserDefaults standardUserDefaults] setObject:favoitesSetting forKey:favoitesPreferenceName];
	}
	[_filterArray setArray:favoitesSetting];

	_filteredArray = [[NSMutableArray alloc] init];
	[self updateFilteredArray];

	warningArray = [[NSMutableArray alloc] init];
	weekDictionary = [[NSMutableDictionary alloc] init];
	dataLoaded = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (!dataLoaded) {
		[self loadData];
		dataLoaded = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeSetting:)];
	self.tabBarController.navigationItem.rightBarButtonItem = item;

	UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	self.tabBarController.navigationItem.leftBarButtonItem = reloadItem;
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
	self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	if (!self.view) {
		_filterArray = nil;
		_filteredArray = nil;
		_favArray = nil;
		warningArray = nil;
		weekDictionary = nil;
	}
}

#pragma mark -
#pragma mark Provate Methods

- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
}
- (void)pushWeekViewController:(NSDictionary *)result
{
	TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = result[@"locationName"];
	controller.forecastArray = result[@"items"];
	NSString *dateString = result[@"publishTime"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromString:dateString];
	controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
	[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
}

#pragma mark Actions

- (IBAction)changeSetting:(id)sender
{
	if (isLoading || isLoadingWeek) {
		return;
	}

	self.tabBarController.selectedIndex = 0;
	TWLocationSettingTableViewController *controller = [[TWLocationSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[controller setFilter:_filterArray];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.tabBarController presentViewController:navController animated:YES completion:nil];
}
- (IBAction)reload:(id)sender
{
	if (isLoading || isLoadingWeek) {
		return;
	}
	self.tabBarController.selectedIndex = 0;
	[self loadData];
}
- (void)updateFilteredArray
{
	[_filteredArray removeAllObjects];
	for (NSNumber *number in _filterArray) {
		NSUInteger index = [number intValue];
		if ([_favArray count]  > index) {
			NSDictionary *d = _favArray[index];
			[_filteredArray addObject:d];
		}
	}
}
- (void)loadData
{
	[self showLoadingView];

	[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
	[[TWAPIBox sharedBox] fetchWarningsWithDelegate:self userInfo:nil];
}
- (void)showLoadingView
{
	CGFloat w = (CGRectGetWidth(self.tableView.bounds) - 120) / 2;
	loadingView.frame = CGRectMake(w, 120, 120, 120);
	loadingView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;

	[self.view addSubview:loadingView];
	[loadingView startAnimating];
	isLoading = YES;
	self.tableView.userInteractionEnabled = NO;
}
- (void)hideLoadingView
{
	[loadingView stopAnimating];
	isLoading = NO;
	self.tableView.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (![_filteredArray count]) {
		return 1;
	}
	return [_filteredArray count] + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		NSUInteger count = [warningArray count];
		for (NSDictionary *dictionary in warningArray) {
			NSString *name = dictionary[@"name"];
			if ([name rangeOfString:@"颱風"].location != NSNotFound) {
				return count + 1;
			}
		}
		return count;
	}

	if ([_filteredArray count]) {
		return 2;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *WarningCellIdentifier = @"WarningCellIdentifier";

	if (indexPath.section == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WarningCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarningCellIdentifier];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if (indexPath.row >= [warningArray count]) {
			cell.textLabel.text = @"人事行政局網頁";
			cell.imageView.image = nil;
			cell.textLabel.textColor = [UIColor blackColor];
		}
		else {
			NSDictionary *dictionary = warningArray[indexPath.row];
			cell.textLabel.text = dictionary[@"name"];
			cell.imageView.image = [UIImage imageNamed:@"alert.png"];
			cell.textLabel.textColor = [UIColor redColor];
		}
		return cell;
	}

	static NSString *CellIdentifier = @"Cell";
	static NSString *SectionCellIdentifier = @"SectionCell";

	NSDictionary *item = _filteredArray[indexPath.section - 1];

	if (indexPath.row == 0) {
		TWFavoriteSectionCell *cell = (TWFavoriteSectionCell *)[tableView dequeueReusableCellWithIdentifier:SectionCellIdentifier];
		if (cell == nil) {
			cell = [[TWFavoriteSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionCellIdentifier];
		}
//		cell.textLabel.text = [item objectForKey:@"locationName"];
		cell.locationName = item[@"locationName"];
		if (isLoadingWeek && loadingWeekIndex == indexPath.section - 1) {
			cell.loading = YES;
		}
		else {
			cell.loading = NO;
		}
		[cell setNeedsDisplay];
		return cell;
	}

	TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	if ([item isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dictionary = item[@"items"][0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
	}
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (isLoading || isLoadingWeek) {
		return;
	}

	if (indexPath.section == 0) {
		if (indexPath.row >= [warningArray count]) {
			TWWebController *webController = [[TWWebController alloc] init];
			webController.title = @"人事行政總處網頁";
			[[TWWeatherAppDelegate sharedDelegate] pushViewController:webController animated:YES];
			[webController view];
			[webController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dgpa.gov.tw/"]]];
			return;
		}
		NSDictionary *dictionary = warningArray[indexPath.row];
		TWOverviewViewController *controller = [[TWOverviewViewController alloc] init];
		[controller setText:dictionary[@"text"]];
		controller.title = dictionary[@"name"];
		[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
		return;
	}

	NSDictionary *dictionary = _filteredArray[indexPath.section - 1];

	if (indexPath.row == 0) {
		NSString *weekLocation = dictionary[@"id"];

		if ([weekDictionary valueForKey:weekLocation]) {
			NSDictionary *result = [weekDictionary valueForKey:weekLocation];
			[self pushWeekViewController:result];
			return;
		}

		isLoadingWeek = YES;
		loadingWeekIndex = indexPath.section - 1;
		[tableView reloadData];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:weekLocation delegate:self userInfo:nil];
		return;
	}

	TWForecastResultTableViewController *controller = [[TWForecastResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = dictionary[@"locationName"];
	controller.forecastArray = dictionary[@"items"];
	NSString *weekLocation = dictionary[@"id"];
	controller.weekLocation = weekLocation;

	if ([weekDictionary valueForKey:weekLocation]) {
		NSDictionary *result = [weekDictionary valueForKey:weekLocation];
		controller.weekDictionary = result;
	}
	[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == [_filteredArray count] && self.updateDate) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:kCFDateFormatterMediumStyle];
		[formatter setTimeStyle:kCFDateFormatterMediumStyle];
		NSString *s = [formatter stringFromDate:self.updateDate];
		NSString *footerTitle = [NSString stringWithFormat:NSLocalizedString(@"Updated at %@", @""), s];
		return footerTitle;
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 40.0;
	}
	if (indexPath.row == 0) {
		return 30.0;
	}
	return 112.0;
}

#pragma mark -
#pragma mark TWLocationSettingTableViewController delegate methods

- (void)settingController:(TWLocationSettingTableViewController *)controller didUpdateFilter:(NSArray *)filterArray
{
	[self hideLoadingView];
	[_filterArray setArray:filterArray];
	[[NSUserDefaults standardUserDefaults] setObject:_filterArray forKey:favoitesPreferenceName];
	if (_favArray) {
		[self updateFilteredArray];
		[self.tableView reloadData];
	}
	else if (!isLoading) {
		[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
	}
}

#pragma mark -
#pragma mark TWWeatherAPI delegate methods

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo
{
	[self hideLoadingView];
	if ([result isKindOfClass:[NSArray class]]) {
		self.tableView.hidden = NO;
		NSArray *array = (NSArray *)result;
		[_favArray setArray:array];
		[self updateFilteredArray];
		self.updateDate = userInfo;
		[[NSUserDefaults standardUserDefaults] setObject:_favArray forKey:lastAllForecastsPreferenceName];
	}
	else if (![_favArray count]) {
		self.tableView.hidden = YES;
		errorLabel.text = NSLocalizedString(@"Failed to load data!", @"");
	}
	[self.tableView reloadData];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchAllForecastsWithError:(NSError *)error
{
	[self hideLoadingView];
	self.tableView.hidden = YES;
	errorLabel.text = [error localizedDescription];
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo
{
	[self hideLoadingView];
	if ([result isKindOfClass:[NSArray class]]) {
		[warningArray setArray:result];
	}
	[self.tableView reloadData];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error
{

}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	if ([result isKindOfClass:[NSDictionary class]]) {
		weekDictionary[identifier] = result;
		[self pushWeekViewController:result];
	}
}

- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	[self pushErrorViewWithError:error];
}


@synthesize updateDate;
@synthesize tableView = _tableView;

@end
