//
// TWAPIBox.m
//
// Copyright (c) Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//     * Redistributions of source code must retain the above
//       copyright notice, this list of conditions and the following
//       disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials
//       provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the names of
//       its contributors may be used to endorse or promote products
//       derived from this software without specific prior written
//       permission.
//
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.

#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWAPIBox+Cache.h"
#import "TWAPIBox+Private.h"
#import <objc/runtime.h>
#include <objc/message.h>

NSString *TWAPIErrorDomain = @"TWAPIErrorDomain";

static TWAPIBox *apibox = nil;

@implementation TWAPIBox

+ (TWAPIBox *)sharedBox
{
	if (!apibox) {
		apibox = [[TWAPIBox alloc] init];
	}
	return apibox;
}

- (void)dealloc
{
	[self releaseInfoArrays];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self initInfoArrays];
		_operationQueue = [[NSOperationQueue alloc] init];
		[_operationQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (void)cancelAllRequest
{
	[_operationQueue cancelAllOperations];
}
- (void)cancelAllRequestWithDelegate:(id)delegate
{
	if (!delegate) {
		return;
	}

	NSArray *operations = [NSArray arrayWithArray:[_operationQueue operations]];
	for (TWFetchOperation *op in operations) {
		id sessionInfo = op.sessionInfo;
		id theDelegate = sessionInfo[@"delegate"];
		if (theDelegate == delegate) {
			[op cancel];
		}
	}
}

- (void)sendRequestWithPath:(NSString *)path identifier:(NSString *)identifier action:(SEL)action failedAction:(SEL)failedAction delegate:(id)delegate userInfo:(id)userInfo
{
	NSMutableDictionary *sessionInfo = [NSMutableDictionary dictionary];
	if (delegate) {
		sessionInfo[@"delegate"] = delegate;
	}
	if (userInfo) {
		sessionInfo[@"userInfo"] = userInfo;
	}
	if (identifier) {
		sessionInfo[@"identifier"] = identifier;
	}
	sessionInfo[@"action"] = NSStringFromSelector(action);
	sessionInfo[@"failedAction"] = NSStringFromSelector(failedAction);
	NSString *URLString = [BASE_URL_STRING stringByAppendingString:path];
	NSURL *URL = [NSURL URLWithString:URLString];
	sessionInfo[@"URL"] = URL;

	if ([identifier isEqualToString:@"image"]) {
		if ([self shouldUseCachedDataForURL:URL]) {
			NSData *data = [self dataInCacheForURL:URL];
			LFHTTPRequest *request = [[LFHTTPRequest alloc] init];
			request.sessionInfo = sessionInfo;
			[self didFetchImage:request data:data];
			return;
		}
	}


	TWFetchOperation *operation = [[TWFetchOperation alloc] initWithDelegate:self sessionInfo:sessionInfo];

#if TARGET_OS_IPHONE

	NSString *filePath = @"/Applications/Cydia.app";
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		operation.note = @"Has Cydia";
	}

#endif

	[_operationQueue addOperation:operation];
}

#pragma mark -

- (void)fetchWarningsWithDelegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = @"warning";
	[self sendRequestWithPath:path identifier:@"warning" action:@selector(didFetchWarning:data:) failedAction:@selector(didFailedFetchWarning:error:) delegate:delegate userInfo:userInfo];

}
- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = @"overview";
	if (format == TWOverviewPlainFormat) {
		path = @"overview?output=plain";
	}
	[self sendRequestWithPath:path identifier:@"overview" action:@selector(didFetchOverview:data:) failedAction:@selector(didFailedFetchOverview:error:) delegate:delegate userInfo:userInfo];
}
- (void)fetchAllForecastsWithDelegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"forecast?location=all"];
	[self sendRequestWithPath:path identifier:@"forecastAll" action:@selector(didFetchWarning:data:) failedAction:@selector(didFailedFetchWarning:error:) delegate:delegate userInfo:userInfo];
}
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	if (!identifier) {
		return;
	}
	NSString *path = [NSString stringWithFormat:@"forecast?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"forecast" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchWeekWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"week2?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"week" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchWeekTravelWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"week_travel?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"week_travel" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchThreeDaySeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"3sea?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"3sea" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchNearSeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"nearsea?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"nearsea" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchTideWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"tide?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"tide" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchImageWithIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=1", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"image" action:@selector(didFetchImage:data:) failedAction:@selector(didFailedFetchImage:error:) delegate:delegate userInfo:info];
}
- (void)fetchOBSWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"obs?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"obs" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchGlobalCityWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"global?location=%@", identifier];
	NSDictionary *info = userInfo ? @{@"identifier": identifier, @"userInfo": userInfo} : @{@"identifier": identifier};
	[self sendRequestWithPath:path identifier:@"global" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}

- (void)setShouldWaitUntilDone:(BOOL)flag
{
	shouldWaitUntilDone = flag;
}
- (BOOL)shouldWaitUntilDone
{
	return shouldWaitUntilDone;
}

- (NSURL *)imageURLFromIdentifier:(NSString *)identifier
{
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=0", identifier];
	NSString *URLString = [BASE_URL_STRING stringByAppendingString:path];
	NSURL *URL = [NSURL URLWithString:URLString];
	return URL;
}

#pragma mark -

- (NSDate *)dateFromString:(NSString *)string
{
	if (!string) {
		return nil;
	}
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
		[_formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
	}
	[_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [_formatter dateFromString:string];
	return date;
}
- (NSDate *)dateFromShortString:(NSString *)string
{
	if (!string) {
		return nil;
	}
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
		[_formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
	}
	[_formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [_formatter dateFromString:string];
	return date;
}
- (NSString *)shortDateTimeStringFromDate:(NSDate *)date
{
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterShortStyle];
	if (!date) {
		return nil;
	}
	return [_formatter stringFromDate:date];
}
- (NSString *)shortDateStringFromDate:(NSDate *)date
{
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterNoStyle];

	if (!date) {
		return nil;
	}
	NSMutableString *s = [NSMutableString stringWithString:[_formatter stringFromDate:date]];
	[_formatter setDateFormat:@"EEE"];
	[s appendFormat:@" %@", [_formatter stringFromDate:date]];
	return s;
}

#pragma mark -

- (void)performAction:(NSDictionary *)actionDictionary
{
	NSString *actionString = actionDictionary[@"action"];
	SEL action = NSSelectorFromString(actionString);
	LFHTTPRequest *request = actionDictionary[@"request"];
	NSData *data = actionDictionary[@"data"];
//	[self performSelector:action withObject:request withObject:data];
    objc_msgSend(self, action, request, data);
}

- (void)performFailedAction:(NSDictionary *)actionDictionary
{
	NSString *actionString = actionDictionary[@"action"];
	SEL action = NSSelectorFromString(actionString);
	LFHTTPRequest *request = actionDictionary[@"request"];
	NSString *error = actionDictionary[@"error"];
//	[self performSelector:action withObject:request withObject:error];
    objc_msgSend(self, action, request, error);
}

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSData *data = [request receivedData];
	NSURL *URL = (request.sessionInfo)[@"URL"];

	NSMutableDictionary *sessionInfo = request.sessionInfo;
	sessionInfo[@"date"] = [NSDate date];

	NSString *actionString = [request sessionInfo][@"action"];
	if (URL) {
		[self writeDataToCache:data fromURL:URL];
	}
	NSDictionary *d = @{@"action": actionString, @"request": request, @"data": data};
	[self performSelectorOnMainThread:@selector(performAction:) withObject:d waitUntilDone:NO];
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
	NSString *actionString = [request sessionInfo][@"action"];
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:actionString, @"action", request, nil];
	[self performSelectorOnMainThread:@selector(performAction:) withObject:d waitUntilDone:NO];
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
	NSURL *URL = [request sessionInfo][@"URL"];

	if (URL) {
		NSData *data = [self dataInCacheForURL:URL];
		NSMutableDictionary *sessionInfo = request.sessionInfo;

		if (data) {
			NSDate *date = [self dateOfCacheForURL:URL];
			sessionInfo[@"date"] = date;

			NSString *actionString = [request sessionInfo][@"action"];
			NSDictionary *d = @{@"action": actionString, @"request": request, @"data": data};
			[self performSelectorOnMainThread:@selector(performAction:) withObject:d waitUntilDone:NO];
			return;
		}
	}

	NSString *failedActionString = [request sessionInfo][@"failedAction"];
	NSDictionary *d = @{@"action": failedActionString, @"request": request, @"error": error};
	[self performSelectorOnMainThread:@selector(performFailedAction:) withObject:d waitUntilDone:NO];
}

@end
