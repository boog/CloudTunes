@STATIC;1.0;p;15;AppController.jt;5084;@STATIC;1.0;I;21;Foundation/CPObject.ji;19;LibraryDataSource.ji;13;MediaPlayer.jt;4997;objj_executeFile("Foundation/CPObject.j", NO);
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

p;19;LibraryDataSource.jt;2903;@STATIC;1.0;I;21;Foundation/CPObject.jt;2858;


objj_executeFile("Foundation/CPObject.j", NO);

{var the_class = objj_allocateClassPair(CPObject, "LibraryDataSource"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("jsonData"), new objj_ivar("libraryList"), new objj_ivar("filteredList"), new objj_ivar("tableView")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("reloadLibraryWithQuery:"), function $LibraryDataSource__reloadLibraryWithQuery_(self, _cmd, query)
{ with(self)
{
    jsonData = "";
    var request = objj_msgSend(objj_msgSend(CPURLRequest, "alloc"), "initWithURL:", SERVER + "?q=" + escape(query));
    objj_msgSend(request, "setHTTPMethod:", "GET");

    var urlConnection = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", request, self);
    objj_msgSend(urlConnection, "start");
}
},["void","CPString"]), new objj_method(sel_getUid("valueForField:atRow:"), function $LibraryDataSource__valueForField_atRow_(self, _cmd, field, rowIndex)
{ with(self)
{
    var item = objj_msgSend(libraryList, "objectAtIndex:", rowIndex);
    return objj_msgSend(item, "objectForKey:", field);
}
},["CPString","CPString","int"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $LibraryDataSource__connection_didReceiveData_(self, _cmd, connection, data)
{ with(self)
{
    jsonData += data;
}
},["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("connectionDidFinishLoading:"), function $LibraryDataSource__connectionDidFinishLoading_(self, _cmd, connection)
{ with(self)
{

    var jsonObject = objj_msgSend(jsonData, "objectFromJSON");
    libraryList = objj_msgSend(CPArray, "array");
    for (i=0; i<jsonObject.length; i++)
    {
        var testDictionary = objj_msgSend(CPDictionary, "dictionaryWithJSObject:recursively:", jsonObject[i], YES);
        objj_msgSend(libraryList, "addObject:", testDictionary);
    }

    objj_msgSend(tableView, "reloadData");
}
},["void","CPURLConnection"]), new objj_method(sel_getUid("numberOfRowsInTableView:"), function $LibraryDataSource__numberOfRowsInTableView_(self, _cmd, sender)
{ with(self)
{
    return objj_msgSend(libraryList, "count");
}
},["int","id"]), new objj_method(sel_getUid("tableView:objectValueForTableColumn:row:"), function $LibraryDataSource__tableView_objectValueForTableColumn_row_(self, _cmd, sender, col, rowIndex)
{ with(self)
{
    var colIdentifier = objj_msgSend(col, "identifier");
    return objj_msgSend(self, "valueForField:atRow:", colIdentifier, rowIndex);
}
},["id","id","CPTableColumn","int"]), new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"), function $LibraryDataSource__tableView_sortDescriptorsDidChange_(self, _cmd, tv, oldDescriptors)
{ with(self)
{
    CPLog("Sorting with descriptor: %@", objj_msgSend(tv, "sortDescriptors"));


}
},["void","CPTableView","CPArray"])]);
}

p;6;main.jt;295;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;15;AppController.jt;209;objj_executeFile("Foundation/Foundation.j", NO);
objj_executeFile("AppKit/AppKit.j", NO);
objj_executeFile("AppController.j", YES);
main= function(args, namedArgs)
{
    CPApplicationMain(args, namedArgs);
}

p;13;MediaPlayer.jt;3020;@STATIC;1.0;I;21;Foundation/CPObject.jt;2975;


objj_executeFile("Foundation/CPObject.j", NO);

{var the_class = objj_allocateClassPair(CPObject, "MediaPlayer"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("audioElement"), new objj_ivar("delegate")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $MediaPlayer__init(self, _cmd)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("MediaPlayer").super_class }, "init"))
    {
        audioElement = document.createElement("audio");
    }
    return self;
}
},["id"]), new objj_method(sel_getUid("setDelegate:"), function $MediaPlayer__setDelegate_(self, _cmd, obj)
{ with(self)
{
 delegate = obj;
}
},["void","id"]), new objj_method(sel_getUid("didFinishPlaying"), function $MediaPlayer__didFinishPlaying(self, _cmd)
{ with(self)
{
 CPLog("did finish playing!");
 CPLog("duration:%@ current position: %@", objj_msgSend(self, "duration"), objj_msgSend(self, "currentPositionInSecs"));
 if (objj_msgSend(self, "duration") == objj_msgSend(self, "currentPositionInSecs"))
 {
  CPLog("Is reallllly finished");
 }

}
},["void"]), new objj_method(sel_getUid("playSong:"), function $MediaPlayer__playSong_(self, _cmd, urlResource)
{ with(self)
{



    audioElement.setAttribute('src', urlResource);

 audioElement.addEventListener('canplaythrough', function() {
  audioElement.load();
  audioElement.play();
  audioElement.addEventListener('ended', objj_msgSend(self, "didFinishPlaying"), false);
     CPLog("did start playing " + audioElement.src);
 }, false);


}
},["void","CPString"]), new objj_method(sel_getUid("setVolume:"), function $MediaPlayer__setVolume_(self, _cmd, ratio)
{ with(self)
{
    audioElement.volume = ratio;
}
},["void","int"]), new objj_method(sel_getUid("seekToTime:"), function $MediaPlayer__seekToTime_(self, _cmd, timeInSecs)
{ with(self)
{
    audioElement.currentTime = timeInSecs;
}
},["void","int"]), new objj_method(sel_getUid("isPlaying"), function $MediaPlayer__isPlaying(self, _cmd)
{ with(self)
{
    return !audioElement.paused;
}
},["boolean"]), new objj_method(sel_getUid("pause"), function $MediaPlayer__pause(self, _cmd)
{ with(self)
{
    audioElement.pause();
}
},["void"]), new objj_method(sel_getUid("play"), function $MediaPlayer__play(self, _cmd)
{ with(self)
{
    audioElement.play();
}
},["void"]), new objj_method(sel_getUid("togglePlaying"), function $MediaPlayer__togglePlaying(self, _cmd)
{ with(self)
{
    if (objj_msgSend(self, "isPlaying"))
    {
        objj_msgSend(self, "pause");
    }
    else
    {
        objj_msgSend(self, "play");
    }
}
},["void"]), new objj_method(sel_getUid("duration"), function $MediaPlayer__duration(self, _cmd)
{ with(self)
{
    return audioElement.duration;
}
},["int"]), new objj_method(sel_getUid("currentPositionInSecs"), function $MediaPlayer__currentPositionInSecs(self, _cmd)
{ with(self)
{
    return audioElement.currentTime;
}
},["int"])]);
}

e;