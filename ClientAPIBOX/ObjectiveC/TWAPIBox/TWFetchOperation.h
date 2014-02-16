//
// TWFetchOperation.h
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

#import <Foundation/Foundation.h>
#import "LFHTTPRequest.h"
#import "LFSiteReachability.h"

#ifdef TARGET_OS_IPHONE
	#import <UIKit/UIKit.h>
#endif

#define BASE_URL_STRING @"https://twweatherapi.herokuapp.com/"

@interface TWFetchOperation : NSOperation <LFSiteReachabilityDelegate>
{
	id delegate;
	LFHTTPRequest *_request;
	LFSiteReachability *_reachability;
	id sessionInfo;
	NSUInteger _retryCount;
	NSString *note;

	BOOL runloopRunning;
}

- (id)initWithDelegate:(id)delegate sessionInfo:(id)sessionInfo;

@property (readonly, nonatomic) id sessionInfo;
@property (strong, nonatomic) NSString *note;

@end
