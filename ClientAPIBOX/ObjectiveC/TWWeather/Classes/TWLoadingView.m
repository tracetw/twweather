//
// TWLoadingView.m
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

#import "TWLoadingView.h"

static NSString *TWLoadingViewAnimationID = @"TWLoadingViewAnimationID";

@implementation TWLoadingView


- (void)resetActivityIndicator
{
	CGRect frame = self.frame;
	CGFloat x = (frame.size.width - 40) / 2;
	CGFloat y = (frame.size.height - 40) / 2;
	CGRect rect = CGRectMake(x, y, 40, 40);
	activityIndicator.frame = rect;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		originalFrame = frame;
		self.backgroundColor = [UIColor clearColor];
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicator.hidesWhenStopped = YES;
		[self resetActivityIndicator];
		[self addSubview:activityIndicator];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect selfRect = [self bounds];
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat radius = 10;

	CGFloat left = selfRect.origin.x + 10, top = selfRect.origin.y + 10, width = selfRect.size.width - 20, height = selfRect.size.height - 20;

	CGPathMoveToPoint(path, NULL, left, top + radius);
	CGPathAddArcToPoint(path, NULL, left, top, left + radius, top, radius);
	CGPathAddLineToPoint(path, NULL, left + width - radius, top);
	CGPathAddArcToPoint(path, NULL, left + width, top, left + width, top + radius, radius);
	CGPathAddLineToPoint(path, NULL, left + width, top + height - radius);
	CGPathAddArcToPoint(path, NULL, left + width, top + height, left + width - radius, top + height, radius);
	CGPathAddLineToPoint(path, NULL, left + radius, top + height);
	CGPathAddArcToPoint(path, NULL, left, top + height, left, top + height - radius, radius);
	CGPathCloseSubpath(path);
	CGContextAddPath(context, path);

	CGFloat black[] = {0.0, 0.0, 0.0, 0.7 * self.opaque};
	CGContextSetFillColor(context, black);
	CGContextFillPath(context);
	CGPathRelease(path);
}

#pragma mark Actions

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	self.frame = originalFrame;
	[self resetActivityIndicator];
	[super removeFromSuperview];
}

- (void)startAnimating
{
	[activityIndicator startAnimating];
}
- (void)stopAnimating
{
	if (![self superview]) {
		return;
	}

	[activityIndicator stopAnimating];

	CGRect newFrame = self.frame;
	newFrame.origin.x += 50;
	newFrame.origin.y += 50;
	newFrame.size.width -= 100;
	newFrame.size.height -= 100;

	[UIView beginAnimations:TWLoadingViewAnimationID context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	self.frame = newFrame;

	[UIView commitAnimations];
}

@end

