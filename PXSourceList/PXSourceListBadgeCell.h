//
//  PXSourceListBadgeCell.h
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

@import Cocoa;

/* This is the cell which backs drawing done by PXSourceListBadgeView, and is used internally for
   drawing badges when PXSourceList is used in cell-based mode.
 
   You shouldn't need to interact with this class directly.
 */
@interface PXSourceListBadgeCell : NSCell

@property (nonatomic, strong) NSColor* textColor;
@property (nonatomic, strong) NSColor* backgroundColor;
@property (nonatomic, assign) NSUInteger badgeValue;

@end
