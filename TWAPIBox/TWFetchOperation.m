//
// TWFetchOperation.m
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

#import "TWFetchOperation.h"
#import "TWAPIBox.h"

@implementation TWFetchOperation


- (instancetype)initWithDelegate:(id)newDelegate sessionInfo:(id)newSessionInfo;
{
	self = [super init];
	if (self != nil) {
		delegate = newDelegate;
		sessionInfo = newSessionInfo;

		_reachability = [[LFSiteReachability alloc] init];
		_reachability.siteURL = [NSURL URLWithString:BASE_URL_STRING];
		_reachability.timeoutInterval = 5.0;
		_reachability.delegate = self;

		_request = [[LFHTTPRequest alloc] init];
		_request.timeoutInterval = 5.0;
		_request.sessionInfo = sessionInfo;
		_request.delegate = self;

		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSDictionary *infoDictionary = [bundle infoDictionary];
		NSString *clientName = infoDictionary[@"CFBundleDisplayName"];
		NSString *version = infoDictionary[@"CFBundleVersion"];
		NSString *userAgent = [NSString stringWithFormat:@"%@ %@", clientName, version];

#ifdef TARGET_OS_IPHONE
		UIDevice *d = [UIDevice currentDevice];
		NSString *deviceInfo = [NSString stringWithFormat:@" (%@/%@ %@)", d.model, d.systemName, d.systemVersion];
		userAgent = [userAgent stringByAppendingString:deviceInfo];
#endif

		[_request setUserAgent:userAgent];
	}
	return self;
}

- (void)cancel
{
	[super cancel];
	runloopRunning = NO;
}

- (BOOL)isConcurrent
{
	return YES;
}

- (void)main
{
	@try {
		@autoreleasepool {
			runloopRunning = YES;

			BOOL shouldWaitUntilDone = NO;
			if ([delegate respondsToSelector:@selector(shouldWaitUntilDone)]) {
				shouldWaitUntilDone = [(TWAPIBox *)delegate shouldWaitUntilDone];
			}

			if (!shouldWaitUntilDone) {
				[_reachability startChecking];
			}
			else {
				_request.shouldWaitUntilDone = YES;
				NSURL *URL = sessionInfo[@"URL"];
				[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
			}

			while (runloopRunning && ![self isCancelled]) {
				[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
			}
		}
	}
	@catch(...) {
		[delegate httpRequestDidCancel:_request];
	}
}

- (void)doFetch
{
	NSURL *URL = (_request.sessionInfo)[@"URL"];
//	NSLog(@"doFetch");

	NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSDictionary *infoDictionary = [bundle infoDictionary];
	deviceInfo[@"app_name"] = infoDictionary[@"CFBundleDisplayName"];
	deviceInfo[@"app_version"] = infoDictionary[@"CFBundleVersion"];
	if (note) {
		deviceInfo[@"note"] = note;
	}
	else {
		deviceInfo[@"note"] = @"";
	}

	NSMutableString *URLString = [NSMutableString stringWithString:[URL absoluteString]];
	NSRange range = [URLString rangeOfString:@"?"];
	if (range.location == NSNotFound) {
		[URLString appendString:@"?"];
	}
	for (NSString *key in [deviceInfo allKeys]) {
		NSString *v = [deviceInfo[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[URLString appendFormat:@"&%@=%@", key, v];
	}
	URL =  [NSURL URLWithString:URLString];
	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
}

#pragma mark -

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSData *data = [request receivedData];
	if (![data length]) {
		if (!_retryCount) {
			_retryCount++;
			[self doFetch];
		}
		else {
			[delegate httpRequest:request didFailWithError:LFHTTPRequestTimeoutError];
			runloopRunning = NO;
		}
		return;
	}

	[delegate httpRequestDidComplete:request];
	runloopRunning = NO;
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
	[delegate httpRequestDidCancel:request];
	runloopRunning = NO;
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
	if (!_retryCount) {
		_retryCount++;
		NSURL *URL = (request.sessionInfo)[@"URL"];
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		return;
	}
	[delegate httpRequest:request didFailWithError:error];
	runloopRunning = NO;
}

#pragma mark -

- (void)reachability:(LFSiteReachability *)inReachability site:(NSURL *)inURL isAvailableOverConnectionType:(NSString *)inConnectionType
{
	[inReachability stopChecking];
	[self doFetch];
}
- (void)reachability:(LFSiteReachability *)inReachability siteIsNotAvailable:(NSURL *)inURL
{
	[inReachability stopChecking];
	[delegate httpRequest:_request didFailWithError:LFHTTPRequestConnectionError];
	runloopRunning = NO;
}

@synthesize sessionInfo;
@synthesize note;

@end
