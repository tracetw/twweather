#import "TWFacebookController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWFacebookController

- (void)removeOutletsAndControls_TWFacebookController
{
	// remove and clean outlets and controls here
}

- (void)dealloc
{
	[self removeOutletsAndControls_TWFacebookController];
	[posts release];
	[super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWFacebookController];
}

#pragma mark -
#pragma mark UIViewContoller Methods

- (void)loadView
{
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (!posts) {
		posts = [[NSMutableArray alloc] init];
	}


	NSMutableDictionary *args = [[[NSMutableDictionary alloc] init] autorelease];
	args[@"source_ids"] = @"188341743092";
	FBRequest *request = [FBRequest requestWithDelegate:self];
	[request call:@"stream.get" params:args];

}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [posts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	NSDictionary *item = posts[indexPath.row];
	cell.textLabel.text = [item valueForKey:@"message"];
	return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)aCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Remenber to redraw the cell if you used a customized one.
	[aCell setNeedsDisplay];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}

- (void)requestLoading:(FBRequest*)request
{
}
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
}
- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"result:%@", [result description]);
	[posts addObjectsFromArray:[result valueForKey:@"posts"]];
	[self.tableView reloadData];
}
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"error:%@", [error description]);
}

@end

