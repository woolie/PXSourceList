//
//  PXSourceListBadgeCell.m
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "PXSourceListBadgeCell.h"

#import "PXSourceList.h"

// Drawing constants

static inline NSColor* badgeBackgroundColor() { return [NSColor colorWithCalibratedRed:(152.0 / 255.0) green:(168.0 / 255.0) blue:(202.0 / 255.0) alpha:1.0]; }
static inline NSColor* badgeHiddenBackgroundColor() { return [NSColor colorWithDeviceWhite:(180.0 / 255.0) alpha:1.0]; }
static inline NSColor* badgeSelectedTextColor() { return [NSColor keyboardFocusIndicatorColor]; }
static inline NSColor* badgeSelectedUnfocusedTextColor() { return [NSColor colorWithCalibratedRed:(153.0 / 255.0) green:(169.0 / 255.0) blue:(203.0 / 255.0) alpha:1.0]; }
static inline NSColor* badgeSelectedHiddenTextColor() { return [NSColor colorWithCalibratedWhite:(170.0 / 255.0) alpha:1.0]; }
static inline NSFont*  badgeFont() { return [NSFont boldSystemFontOfSize:11.0]; }

// Sizing constants.

static const CGFloat kBadgeLeftAndRightPadding = 5.0;

@implementation PXSourceListBadgeCell

- (instancetype) init
{
    self = [super initTextCell: @""];
    if( self )
    {
        ;
    }

    return self;
}

- (void) drawWithFrame:(NSRect) cellFrame inView:(NSView*) controlView
{
    CGFloat borderRadius = NSHeight( cellFrame ) * 0.5;
	NSBezierPath* badgePath = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:borderRadius yRadius:borderRadius];

	// Get the window and control state to determine the badge colours used.

    BOOL isMainWindowVisible = [NSApp mainWindow].isVisible;
	NSDictionary* attributes = nil;
	NSColor* backgroundColor = [NSColor whiteColor];

	if( self.isHighlighted || self.backgroundStyle == NSBackgroundStyleDark )
    {
        NSResponder *firstResponder = controlView.window.firstResponder;
        BOOL isFocused = NO;

        // Starting with the closest ancestor of the control view and the first responder (to make sure both views are in the
        // same subtree of the view hierarchy), keep going up the view hierarchy until we hit a PXSourceList instance to tell
        // if the source list is focused.
        // This covers both the cell-based and view-based cases as well as if a child view of the NSTableCellView (such as
        // a text field) is focused.

        if ([firstResponder isKindOfClass:[NSView class]])
        {
            NSView *view = [(NSView*)firstResponder ancestorSharedWithView:controlView];
            do
            {
                if( [view isKindOfClass:[PXSourceList class]] )
                {
                    isFocused = YES;
                    break;
                }
            } while( (view = [view superview]) );
        }

        NSColor* textColor = badgeSelectedHiddenTextColor();

		if( isMainWindowVisible && isFocused )
			textColor = badgeSelectedTextColor();
		else if( isMainWindowVisible && !isFocused )
			textColor = badgeSelectedUnfocusedTextColor();

        attributes = @{ NSForegroundColorAttributeName: textColor };
    }
    else
    {
		NSColor *textColor = textColor = self.textColor ? self.textColor : [NSColor whiteColor];;

		if( isMainWindowVisible )
            backgroundColor = self.backgroundColor ? self.backgroundColor : badgeBackgroundColor();
		else
			backgroundColor = badgeHiddenBackgroundColor();

		attributes = @{NSForegroundColorAttributeName: textColor};
	}

	[backgroundColor set];
	[badgePath fill];

	// Draw the badge text

    NSMutableAttributedString* badgeString = [self.badgeString mutableCopy];
    [badgeString addAttributes:attributes range:NSMakeRange( 0, badgeString.length )];

	NSSize stringSize = badgeString.size;
	NSPoint badgeTextPoint = NSMakePoint( NSMidX( cellFrame ) - (stringSize.width * 0.5), NSMidY( cellFrame ) - (stringSize.height * 0.5) );
	[badgeString drawAtPoint:badgeTextPoint];
}

- (NSSize) cellSize
{
    NSSize size = self.badgeString.size;
    size.width += 2 * kBadgeLeftAndRightPadding;

    return size;
}

- (NSAttributedString*) badgeString
{
	return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.badgeValue]
                                           attributes:@{ NSFontAttributeName : badgeFont() }];
}

#if 0 // Deprecated. Consider using the View based PXSourceList.

- (id) accessibilityAttributeValue:(NSString*) attribute
{
    if( [attribute isEqualToString:NSAccessibilityValueAttribute] )
        return @(_badgeValue).description;
    else
        return [super accessibilityAttributeValue:attribute];
}

#endif

@end
