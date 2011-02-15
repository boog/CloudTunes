/*
 * AppController.j
 * CloudTunes
 *
 * Created by You on December 4, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "LibraryDataSource.j"
@import "MediaPlayer.j"

SERVER = @"/music";// @"http://emma.baileycarlson.net:8124/music/";

@implementation AppController : CPObject
{
    @outlet CPWindow    	theWindow; 		//this "outlet" is connected automatically by the Cib
    @outlet CPScrollView 	scrollView;
    @outlet CPTableView 	tableView;
    @outlet CPSearchField 	searchField;
    @outlet CPSlider    	volumeSlider;
	@outlet CPSlider		seekSlider; 	// Slider indicates current position of song
    @outlet CPTextField 	nowPlayingLabel;
    LibraryDataSource   	tableDataSource; // Responsible for searching and filling list of songs
    MediaPlayer         	mediaPlayer; 	// Plays the songs with audio tag, notifies of player events
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // Attach tableView to library dataSource to show available music
    tableDataSource = [[LibraryDataSource alloc] init];
    tableDataSource.tableView = tableView;
    [tableView setDataSource:tableDataSource];
    [tableDataSource reloadLibraryWithQuery:@""];

    // Initalize player
    mediaPlayer = [[MediaPlayer alloc] init];
	[mediaPlayer setDelegate:self]; // Notify app of player events
}

- (void)awakeFromCib
{
    [scrollView setDocumentView:tableView];
    // Set tableView visible columns
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    [tableView setSortDescriptors:["Artist","Album","Title"]];
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(didSelectItemToPlay:)];
    [self addColumnIdentifier:@"Title"];
    [self addColumnIdentifier:@"Artist"];
    [self addColumnIdentifier:@"Album"];

    // Set mediaPlayer to observe volumeSlider for volume updates
    [volumeSlider setTarget:self];
    [volumeSlider setAction:@selector(volumeDidChange:)];

    [searchField setTarget:self];
    [searchField setAction:@selector(search:)];
}

- (void)addColumnIdentifier:(CPString)ident
{
    var titleColumn = [[CPTableColumn alloc] initWithIdentifier:ident];
    [titleColumn setHeaderView:[CPTextField labelWithTitle:ident]];
    [titleColumn setMinWidth:200];
    var sortDescriptor = [[CPSortDescriptor alloc] initWithKey:ident ascending:YES];
    [titleColumn setSortDescriptorPrototype:sortDescriptor];
    [tableView addTableColumn:titleColumn];
}

- (CPString)selectedResource
{
	return SERVER + @"?q=" + escape([searchField objectValue]) + "&i=" + [tableDataSource valueForField:@"id" atRow:[tableView selectedRow]];
}

- (void)volumeDidChange:(id)sender
{
    [mediaPlayer setVolume:[volumeSlider doubleValue]/100];
}

- (@action)search:(id)sender
{
    [tableDataSource reloadLibraryWithQuery:[searchField objectValue]];
}

- (@action)didPlayPauseClick:(id)sender
{
	if (![mediaPlayer isPlaying])
	{
		// No song playing, play selected item
		[self didSelectItemToPlay:nil];
	}
	else
	{
	    [mediaPlayer togglePlaying];
	}
}

- (@action)nextSongClick:(id)sender
{
	CPLog(@"Beginning next song in playlist");
	[tableView selectRowIndexes:[CPIndexSet indexSetWithIndex:[tableView selectedRow] + 1] byExtendingSelection:NO];
	[self didSelectItemToPlay:sender];
}

- (void)didSelectItemToPlay:(id)sender
{
    var selectedRowIndex = [tableView selectedRow];
    var songTitle = [tableDataSource valueForField:@"Title" atRow:selectedRowIndex];
    [nowPlayingLabel setObjectValue:@"Playing: " + songTitle];
    [mediaPlayer playSong:[self selectedResource]];
}

- (void)mediaPlayer:(id)player didFinishPlaying:(CPString)resource
{
	[self nextSongClick:player];
}

- (void)mediaPlayer:(id)player currentPositionDidUpdate:(int)seconds
{
	var selectedRowIndex = [tableView selectedRow];
    var songTitle = [tableDataSource valueForField:@"Title" atRow:selectedRowIndex];
	var currentMin = Math.floor(seconds / 60);
	var currentSec = Math.floor(seconds - currentMin * 60);
	var durationMin = Math.floor([player duration] / 60);
	var durationSec = Math.floor([player duration] - durationMin * 60);
	var currentTime = [CPString stringWithFormat:@"%d:%02d", currentMin, currentSec];
	var durationTime = [CPString stringWithFormat:@"%d:%02d", durationMin, durationSec];
	[nowPlayingLabel setObjectValue:@"Playing: " + songTitle + " " + currentTime + "/" + durationTime];
	[seekSlider setObjectValue:seconds / [player duration] * 100];
	[seekSlider setNeedsDisplay:YES];
	[nowPlayingLabel setWantsLayer:YES];
}



@end
