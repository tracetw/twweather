//
// TWBasicForecastTableViewController.m
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

#import "TWBasicForecastTableViewController.h"
#import "TWAPIBox.h"
#import "TWLoadingCell.h"
#import "TWErrorViewController.h"

@implementation TWBasicForecastTableViewController

- (void)dealloc
{
	_searchController = nil;
	_searchBar = nil;
	self.tableView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[TWAPIBox sharedBox] cancelAllRequestWithDelegate:self];
}

- (void)_init
{
	if (!_array) {
		_array = [[NSMutableArray alloc] init];
	}
	if (!_filteredArray) {
		_filteredArray = [[NSMutableArray alloc] init];
	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style]) {
		self.style = style;
		[self _init];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
		[self _init];
	}
	return self;
}

- (void)loadView
{
	[super loadView];

	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		_searchBar.delegate = self;
		if ([[_searchBar subviews] count]) {
			UIView *bgView = [_searchBar subviews][0];
			if (bgView) {
				[bgView setValue:[UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0] forKey:@"tintColor"];
			}
		}
	}
	if (!_searchController) {
		_searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
		_searchController.delegate = self;
		_searchController.searchResultsDataSource = self;
		_searchController.searchResultsDelegate = self;
	}
}


#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.tableHeaderView = _searchBar;
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL];
	_firstTimeVisiable = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (_firstTimeVisiable) {
		[self.tableView scrollRectToVisible:CGRectMake(0, 40, 320, 420) animated:NO];
		_firstTimeVisiable = NO;
	}
	self.searchDisplayController.active = NO;
}

- (void)setArray:(NSArray *)array
{
	[_array removeAllObjects];
	for (NSDictionary *d in array) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:d];
		dictionary[@"isLoading"] = @NO;
		[_array addObject:dictionary];
	}
}
- (NSArray *)arrayForTableView:(UITableView *)tableView
{
	if (tableView == _searchController.searchResultsTableView) {
		return _filteredArray;
	}
	return _array;
}
- (NSArray *)array
{
	return _array;
}

- (void)resetLoading
{
	for (NSMutableDictionary *d in _array) {
		d[@"isLoading"] = @NO;
	}
	[self.tableView reloadData];
	[_searchController.searchResultsTableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	_searchController.searchResultsTableView.userInteractionEnabled = YES;
}
- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *array = [self arrayForTableView:tableView];
	return [array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";

	TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	NSArray *array = [self arrayForTableView:tableView];
	NSDictionary *dictionary = array[indexPath.row];
	NSString *name = dictionary[@"name"];
	cell.textLabel.text = name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if ([dictionary[@"isLoading"] boolValue]) {
		[cell startAnimating];
	}
	else {
		[cell stopAnimating];
	}

	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[_filteredArray removeAllObjects];
	searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	for (NSDictionary *d in _array) {
		NSString *name = d[@"name"];
		NSRange range = [name rangeOfString:searchText];
		if (range.location != NSNotFound) {
			[_filteredArray addObject:d];
		}
	}
}

@dynamic array;
@synthesize style = _style;
@synthesize tableView = _tableView;

@end
