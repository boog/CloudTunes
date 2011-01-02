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

SERVER = @"http://emma.baileycarlson.net:8124/music/"; // @"http://emma.baileycarlson.net:8124/music/";

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
    @outlet CPScrollView scrollView;
    @outlet CPTableView tableView;
    @outlet CPSearchField searchField;
    @outlet CPSlider    volumeSlider;
    @outlet CPTextField nowPlayingLabel;
    LibraryDataSource   tableDataSource;
    MediaPlayer         mediaPlayer;
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
    [mediaPlayer togglePlaying];
}

- (void)didSelectItemToPlay:(id)sender
{
    CPLog(@"Song did began play");
    var selectedRowIndex = [tableView selectedRow];
    var songTitle = [tableDataSource valueForField:@"Title" atRow:selectedRowIndex];
    [nowPlayingLabel setObjectValue:@"Now Playing: " + songTitle];
    [mediaPlayer playSong:SERVER + @"?q=" + escape([searchField objectValue]) + "&i=" + [tableDataSource valueForField:@"id" atRow:selectedRowIndex]];
}

@end
