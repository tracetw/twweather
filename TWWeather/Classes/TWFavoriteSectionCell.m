//
// TWFavoriteSectionCell.m
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


#import "TWFavoriteSectionCell.h"

@interface TWFavoriteSectionCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (void)drawBackground:(CGRect)bounds;
@end

@interface TWFavoriteSectionCellContentView : UIView
{
	TWFavoriteSectionCell *__weak _delegate;
}
@property (weak, nonatomic) TWFavoriteSectionCell *delegate;
@end

@implementation TWFavoriteSectionCellContentView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[_delegate draw:self.bounds];
}

@synthesize delegate = _delegate;
@end

#pragma mark -

@interface TWFavoriteSectionCellBackgroundView : UIView
{
	TWFavoriteSectionCell *__weak _delegate;
}
@property (weak, nonatomic) TWFavoriteSectionCell *delegate;
@end

@implementation TWFavoriteSectionCellBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[_delegate drawBackground:self.bounds];
}

@synthesize delegate = _delegate;
@end

@implementation TWFavoriteSectionCell
{
	TWFavoriteSectionCellContentView *_ourContentView;
	BOOL loading;
	NSString *locationName;
}

- (void)_init
{
	CGRect cellFrame = self.contentView.bounds;
	_ourContentView = [[TWFavoriteSectionCellContentView alloc] initWithFrame:cellFrame];
	_ourContentView.delegate = self;
	_ourContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:_ourContentView];

	TWFavoriteSectionCellBackgroundView *ourBackgroundView = [[TWFavoriteSectionCellBackgroundView alloc] initWithFrame:cellFrame];
	ourBackgroundView.delegate = self;
	ourBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundView = ourBackgroundView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self _init];
		self.loading = NO;
	}
	return self;
}

- (void)draw:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 2.0, [UIColor blackColor].CGColor);

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.lineBreakMode = NSLineBreakByClipping;
	style.alignment = NSTextAlignmentRight;

	CGRect textRect = CGRectMake(10, (rect.size.height - 16.0) / 2.0 , rect.size.width - 26.0, 16.0);
	[@"一週預報" drawInRect:textRect withAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: style}];
	
	textRect = CGRectMake(10, (rect.size.height - 18.0) / 2.0 , rect.size.width - 26.0, 18.0);
	style.alignment = NSTextAlignmentLeft;
	[locationName drawInRect:textRect withAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: style}];

	CGContextRestoreGState(context);
}
- (void)drawBackground:(CGRect)bounds
{
	[[UIColor lightGrayColor] setFill];
	[[UIBezierPath bezierPathWithRect:bounds] fill];

}
- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[_ourContentView setNeedsDisplay];
	[self.backgroundView setNeedsDisplay];
}

- (NSString *)_description
{
	if (![locationName length]) {
		return nil;
	}
	return [NSString stringWithFormat:@"%@ 一週預報", locationName];
}

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

#pragma mark -

- (void)setLoading:(BOOL)flag
{
	loading = flag;
	if (flag) {
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(0, 0, 15, 15);
		[view startAnimating];
		self.accessoryView = view;
	}
	else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
		label.text = @"➲";
		label.font = [UIFont boldSystemFontOfSize:15.0];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		self.accessoryView = label;
	}
}

- (BOOL)isLoading
{
	return loading;
}

@synthesize locationName;

@end
