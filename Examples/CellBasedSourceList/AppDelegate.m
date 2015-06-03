//
//  AppDelegate.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, weak) IBOutlet PXSourceList* sourceList;
@property (nonatomic, weak) IBOutlet NSTextField* selectedItemLabel;
@property (nonatomic, strong) NSMutableArray* sourceListItems;
@end

@implementation AppDelegate

#pragma mark - Init/Dealloc

- (void) awakeFromNib
{
    NSTextField* selectedItemLabel = self.selectedItemLabel;
	selectedItemLabel.stringValue = @"(none)";

	self.sourceListItems = [NSMutableArray new];
	
	//Set up the "Library" parent item and children

    PXSourceListItem* libraryItem = [PXSourceListItem itemWithTitle:@"LIBRARY" identifier:@"library"];
	PXSourceListItem* musicItem = [PXSourceListItem itemWithTitle:@"Music" identifier:@"music"];
	musicItem.icon = [NSImage imageNamed:@"music.png"];
	PXSourceListItem *moviesItem = [PXSourceListItem itemWithTitle:@"Movies" identifier:@"movies"];
	musicItem.icon = [NSImage imageNamed:@"movies.png"];
	PXSourceListItem *podcastsItem = [PXSourceListItem itemWithTitle:@"Podcasts" identifier:@"podcasts"];
	podcastsItem.icon = [NSImage imageNamed:@"podcasts.png"];
	podcastsItem.badgeValue = @10;
	PXSourceListItem *audiobooksItem = [PXSourceListItem itemWithTitle:@"Audiobooks" identifier:@"audiobooks"];
	[audiobooksItem setIcon:[NSImage imageNamed:@"audiobooks.png"]];
	[libraryItem setChildren:[NSArray arrayWithObjects:musicItem, moviesItem, podcastsItem,
							  audiobooksItem, nil]];
	
	//Set up the "Playlists" parent item and children
	PXSourceListItem* playlistsItem = [PXSourceListItem itemWithTitle:@"PLAYLISTS" identifier:@"playlists"];
	PXSourceListItem* playlist1Item = [PXSourceListItem itemWithTitle:@"Playlist1" identifier:@"playlist1"];
	
	//Create a second-level group to demonstrate
	PXSourceListItem* playlist2Item = [PXSourceListItem itemWithTitle:@"Playlist2" identifier:@"playlist2"];
	PXSourceListItem* playlist3Item = [PXSourceListItem itemWithTitle:@"Playlist3" identifier:@"playlist3"];
	playlist1Item.icon = [NSImage imageNamed:@"playlist.png"];
	playlist2Item.icon = [NSImage imageNamed:@"playlist.png"];
	playlist3Item.icon = [NSImage imageNamed:@"playlist.png"];
	
	PXSourceListItem* playlistGroup = [PXSourceListItem itemWithTitle:@"Playlist Group" identifier:@"playlistgroup"];
	PXSourceListItem* playlistGroupItem = [PXSourceListItem itemWithTitle:@"Child Playlist" identifier:@"childplaylist"];
	playlistGroup.icon = [NSImage imageNamed:@"playlistFolder.png"];
	playlistGroupItem.icon =[NSImage imageNamed:@"playlist.png"];
	playlistGroup.children = @[playlistGroupItem];
	
	playlistsItem.children = @[playlist1Item, playlistGroup, playlist2Item, playlist3Item];
	
	[self.sourceListItems addObject:libraryItem];
	[self.sourceListItems addObject:playlistsItem];

    PXSourceList* sourceList = self.sourceList;
	[sourceList reloadData];
}

#pragma mark - Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	// Works the same way as the NSOutlineView data source: `nil` means a parent item

    if(item==nil)
    {
		return [self.sourceListItems count];
	}
	else
    {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item

    if(item==nil)
    {
		return [self.sourceListItems objectAtIndex:index];
	}
	else
    {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return !![(PXSourceListItem *)item badgeValue];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [(PXSourceListItem *)item badgeValue].integerValue;
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return !![item icon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil){
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark - Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"library"])
		return YES;
	
	return NO;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    PXSourceList* sourceList = self.sourceList;

	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSTextField* selectedItemLabel = self.selectedItemLabel;

    //Set the label text to represent the new selection
	if([selectedIndexes count]>1)
    {
		[selectedItemLabel setStringValue:@"(multiple)"];
    }
	else if([selectedIndexes count]==1)
    {
		NSString *identifier = [[sourceList itemAtRow:(NSInteger)[selectedIndexes firstIndex]] identifier];
		
		[selectedItemLabel setStringValue:identifier];
	}
	else
    {
		[selectedItemLabel setStringValue:@"(none)"];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
#if DEBUG
	NSLog(@"Delete key pressed on rows %@", [[notification userInfo] objectForKey:@"rows"]);
#endif

	//Do something here
}

@end
