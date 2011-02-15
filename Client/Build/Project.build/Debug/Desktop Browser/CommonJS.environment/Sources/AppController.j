@STATIC;1.0;I;21;Foundation/CPObject.ji;19;LibraryDataSource.ji;13;MediaPlayer.jt;4997;objj_executeFile("Foundation/CPObject.j", NO);
objj_executeFile("LibraryDataSource.j", YES);
objj_executeFile("MediaPlayer.j", YES);
SERVER = "/music";
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow"), new objj_ivar("scrollView"), new objj_ivar("tableView"), new objj_ivar("searchField"), new objj_ivar("volumeSlider"), new objj_ivar("nowPlayingLabel"), new objj_ivar("tableDataSource"), new objj_ivar("mediaPlayer")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{ with(self)
{
    tableDataSource = objj_msgSend(objj_msgSend(LibraryDataSource, "alloc"), "init");
    tableDataSource.tableView = tableView;
    objj_msgSend(tableView, "setDataSource:", tableDataSource);
    objj_msgSend(tableDataSource, "reloadLibraryWithQuery:", "");
    mediaPlayer = objj_msgSend(objj_msgSend(MediaPlayer, "alloc"), "init");
 objj_msgSend(mediaPlayer, "setDelegate:", self);
}
},["void","CPNotification"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{ with(self)
{
    objj_msgSend(scrollView, "setDocumentView:", tableView);
    objj_msgSend(tableView, "setUsesAlternatingRowBackgroundColors:", YES);
    objj_msgSend(tableView, "setColumnAutoresizingStyle:", CPTableViewLastColumnOnlyAutoresizingStyle);
    objj_msgSend(tableView, "setSortDescriptors:", ["Artist","Album","Title"]);
    objj_msgSend(tableView, "setTarget:", self);
    objj_msgSend(tableView, "setDoubleAction:", sel_getUid("didSelectItemToPlay:"));
    objj_msgSend(self, "addColumnIdentifier:", "Title");
    objj_msgSend(self, "addColumnIdentifier:", "Artist");
    objj_msgSend(self, "addColumnIdentifier:", "Album");
    objj_msgSend(volumeSlider, "setTarget:", self);
    objj_msgSend(volumeSlider, "setAction:", sel_getUid("volumeDidChange:"));
    objj_msgSend(searchField, "setTarget:", self);
    objj_msgSend(searchField, "setAction:", sel_getUid("search:"));
}
},["void"]), new objj_method(sel_getUid("addColumnIdentifier:"), function $AppController__addColumnIdentifier_(self, _cmd, ident)
{ with(self)
{
    var titleColumn = objj_msgSend(objj_msgSend(CPTableColumn, "alloc"), "initWithIdentifier:", ident);
    objj_msgSend(titleColumn, "setHeaderView:", objj_msgSend(CPTextField, "labelWithTitle:", ident));
    objj_msgSend(titleColumn, "setMinWidth:", 200);
    var sortDescriptor = objj_msgSend(objj_msgSend(CPSortDescriptor, "alloc"), "initWithKey:ascending:", ident, YES);
    objj_msgSend(titleColumn, "setSortDescriptorPrototype:", sortDescriptor);
    objj_msgSend(tableView, "addTableColumn:", titleColumn);
}
},["void","CPString"]), new objj_method(sel_getUid("selectedResource"), function $AppController__selectedResource(self, _cmd)
{ with(self)
{
 return SERVER + "?q=" + escape(objj_msgSend(searchField, "objectValue")) + "&i=" + objj_msgSend(tableDataSource, "valueForField:atRow:", "id", objj_msgSend(tableView, "selectedRow"));
}
},["CPString"]), new objj_method(sel_getUid("volumeDidChange:"), function $AppController__volumeDidChange_(self, _cmd, sender)
{ with(self)
{
    objj_msgSend(mediaPlayer, "setVolume:", objj_msgSend(volumeSlider, "doubleValue")/100);
}
},["void","id"]), new objj_method(sel_getUid("search:"), function $AppController__search_(self, _cmd, sender)
{ with(self)
{
    objj_msgSend(tableDataSource, "reloadLibraryWithQuery:", objj_msgSend(searchField, "objectValue"));
}
},["@action","id"]), new objj_method(sel_getUid("didPlayPauseClick:"), function $AppController__didPlayPauseClick_(self, _cmd, sender)
{ with(self)
{
    objj_msgSend(mediaPlayer, "togglePlaying");
}
},["@action","id"]), new objj_method(sel_getUid("nextSongClick:"), function $AppController__nextSongClick_(self, _cmd, sender)
{ with(self)
{
 CPLog("Beginning next song in playlist");
 objj_msgSend(tableView, "selectRowIndexes:byExtendingSelection:", objj_msgSend(CPIndexSet, "indexSetWithIndex:", objj_msgSend(tableView, "selectedRow") + 1), NO);
 objj_msgSend(self, "didSelectItemToPlay:", sender);
}
},["@action","id"]), new objj_method(sel_getUid("didSelectItemToPlay:"), function $AppController__didSelectItemToPlay_(self, _cmd, sender)
{ with(self)
{
    CPLog("Song did began play");
    var selectedRowIndex = objj_msgSend(tableView, "selectedRow");
    var songTitle = objj_msgSend(tableDataSource, "valueForField:atRow:", "Title", selectedRowIndex);
    objj_msgSend(nowPlayingLabel, "setObjectValue:", "Now Playing: " + songTitle);
    objj_msgSend(mediaPlayer, "playSong:", objj_msgSend(self, "selectedResource"));
}
},["void","id"]), new objj_method(sel_getUid("mediaPlayer:didFinishPlaying:"), function $AppController__mediaPlayer_didFinishPlaying_(self, _cmd, player, resource)
{ with(self)
{
 objj_msgSend(self, "nextSongClick:", player);
}
},["void","id","CPString"])]);
}

