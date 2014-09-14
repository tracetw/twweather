//
// TWTideCell.m
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

#import "TWTideCell.h"

@interface TWTideCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWTideCellContentView : UIView
{
	TWTideCell *__weak _delegate;
	NSDate *touchBeginDate;
}
@property (weak, nonatomic) TWTideCell *delegate;
@end

@implementation TWTideCellContentView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		touchBeginDate = nil;
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[_delegate draw:self.bounds];
}
- (BOOL)canBecomeFirstResponder
{
	return YES;
}
- (IBAction)copy:(id)sender
{
	[_delegate copy:sender];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	if (action == @selector(copy:)) {
		return YES;
	}
	return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	touchBeginDate = [NSDate date];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( touchBeginDate && ([[NSDate date] timeIntervalSinceDate:touchBeginDate] > 1.0)) {
		[self becomeFirstResponder];
		[[UIMenuController sharedMenuController] update];
		[[UIMenuController sharedMenuController] setTargetRect:CGRectMake(0, 0, 100, 100) inView:self];
		[[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
	}
	else {
		[super touchesEnded:touches withEvent:event];
	}
	touchBeginDate = nil;
}

@synthesize delegate = _delegate;
@end

@implementation TWTideCell
{
	TWTideCellContentView *_ourContentView;
	NSString *dateString;
	NSString *lunarDateString;

	NSArray *tides;
}

- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 10, 280, 100);
		_ourContentView = [[TWTideCellContentView alloc] initWithFrame:cellFrame];
		_ourContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_ourContentView.delegate = self;
		_ourContentView.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_ourContentView];
	}
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self _init];
	}
	return self;
}
- (NSString *)_description
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", dateString];
	[s appendFormat:@"%@\n", lunarDateString];
	for (NSDictionary *tide in tides) {
		NSString *name = tide[@"name"];
		NSString *shortTime = tide[@"shortTime"];
		NSString *height = tide[@"height"];
		[s appendFormat:@"%@ %@ %@\n", name, shortTime, height];
	}
	return s;
}
- (void)draw:(CGRect)bounds
{
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentRight;
	style.lineBreakMode = NSLineBreakByClipping;

	[dateString drawInRect:CGRectMake(10, 0, 260, 30) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}];
	[lunarDateString drawInRect:CGRectMake(10, 6, 260, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: style}];
	NSUInteger i = 0;
	for (NSDictionary *tide in tides) {
		NSString *name = tide[@"name"];
		NSString *shortTime = tide[@"shortTime"];
		NSString *height = tide[@"height"];
		[name drawInRect:CGRectMake(10, 40.0 + 30 * i, 100, 40) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}];
		[shortTime drawInRect:CGRectMake(90, 44 + 30 * i, 80, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
		[[height stringByAppendingString:@"cm"] drawInRect:CGRectMake(160, 44 + 30 * i, 80, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSParagraphStyleAttributeName: style}];
		i++;
	}
}
- (IBAction)copy:(id)sender
{
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:[self _description]];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

#pragma mark -

- (BOOL)isAccessibilityElement
{
	return YES;
}
- (NSString *)accessibilityLabel
{
	return [self _description];
}
- (UIAccessibilityTraits)accessibilityTraits
{
	return UIAccessibilityTraitNone;
}
- (NSString *)accessibilityLanguage
{
	return @"zh-Hant";
}

@synthesize dateString;
@synthesize lunarDateString;
@synthesize tides;

@end
