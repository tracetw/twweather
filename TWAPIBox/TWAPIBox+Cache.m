//
// TWAPIBox+Cache.m
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

#import "TWAPIBox+Cache.h"
#import "CocoaCryptoHashing.h"

@implementation TWAPIBox(Cache)

- (NSString *)cacheFolderPath
{
#ifdef WIDGET
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSString *cachePath = [docPath stringByAppendingPathComponent:@"net.zonble.twweather.widget"];
#else
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = docPaths[0];
	NSString *cachePath = [docPath stringByAppendingPathComponent:@"cache"];
#endif
	BOOL isDir = NO;
	if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	if (!isDir) {
		[[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return cachePath;
}

- (NSString *)md5HashPathForURLString:(NSString *)string
{
	NSString *md5Hash = [string md5HexHash];
	NSString *part = [md5Hash substringToIndex:5];
	NSString *folderPath = [[self cacheFolderPath] stringByAppendingPathComponent:part];
	BOOL isDir = NO;
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	if (!isDir) {
		[[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return [folderPath stringByAppendingPathComponent:md5Hash];
}

- (BOOL)shouldUseCachedDataForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSDate *fileModDate;
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];		if ((fileModDate = fileAttributes[NSFileModificationDate])) {
			if ([fileModDate timeIntervalSinceNow] > -60.0 * 10) {
				return YES;
			}
			return NO;
		}
	}
	return NO;
}

- (NSData *)dataInCacheForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSDate *date = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileModificationDate];
		if ([date timeIntervalSinceNow] < -60 * 60 * 24 * 7) {
			return nil;
		}
		NSData *data = [NSData dataWithContentsOfFile:path];
		return data;
	}
	return nil;
}
- (NSDate *)dateOfCacheForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	NSDate *date = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		date = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] valueForKey:NSFileModificationDate];
	}
	return date;
}
- (void)writeDataToCache:(NSData *)data fromURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	[data writeToFile:path atomically:YES];
}

@end
