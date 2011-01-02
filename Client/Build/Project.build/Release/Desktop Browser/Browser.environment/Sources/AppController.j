@STATIC;1.0;I;21;Foundation/CPObject.ji;19;LibraryDataSource.ji;13;MediaPlayer.jt;3246;
objj_executeFile("Foundation/CPObject.j",NO);
objj_executeFile("LibraryDataSource.j",YES);
objj_executeFile("MediaPlayer.j",YES);
SERVER="http://emma.baileycarlson.net:8124/music/";
var _1=objj_allocateClassPair(CPObject,"AppController"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("theWindow"),new objj_ivar("scrollView"),new objj_ivar("tableView"),new objj_ivar("searchField"),new objj_ivar("volumeSlider"),new objj_ivar("nowPlayingLabel"),new objj_ivar("tableDataSource"),new objj_ivar("mediaPlayer")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("applicationDidFinishLaunching:"),function(_3,_4,_5){
with(_3){
tableDataSource=objj_msgSend(objj_msgSend(LibraryDataSource,"alloc"),"init");
tableDataSource.tableView=tableView;
objj_msgSend(tableView,"setDataSource:",tableDataSource);
objj_msgSend(tableDataSource,"reloadLibraryWithQuery:","");
mediaPlayer=objj_msgSend(objj_msgSend(MediaPlayer,"alloc"),"init");
}
}),new objj_method(sel_getUid("awakeFromCib"),function(_6,_7){
with(_6){
objj_msgSend(scrollView,"setDocumentView:",tableView);
objj_msgSend(tableView,"setUsesAlternatingRowBackgroundColors:",YES);
objj_msgSend(tableView,"setColumnAutoresizingStyle:",CPTableViewLastColumnOnlyAutoresizingStyle);
objj_msgSend(tableView,"setSortDescriptors:",["Artist","Album","Title"]);
objj_msgSend(tableView,"setTarget:",_6);
objj_msgSend(tableView,"setDoubleAction:",sel_getUid("didSelectItemToPlay:"));
objj_msgSend(_6,"addColumnIdentifier:","Title");
objj_msgSend(_6,"addColumnIdentifier:","Artist");
objj_msgSend(_6,"addColumnIdentifier:","Album");
objj_msgSend(volumeSlider,"setTarget:",_6);
objj_msgSend(volumeSlider,"setAction:",sel_getUid("volumeDidChange:"));
objj_msgSend(searchField,"setTarget:",_6);
objj_msgSend(searchField,"setAction:",sel_getUid("search:"));
}
}),new objj_method(sel_getUid("addColumnIdentifier:"),function(_8,_9,_a){
with(_8){
var _b=objj_msgSend(objj_msgSend(CPTableColumn,"alloc"),"initWithIdentifier:",_a);
objj_msgSend(_b,"setHeaderView:",objj_msgSend(CPTextField,"labelWithTitle:",_a));
objj_msgSend(_b,"setMinWidth:",200);
var _c=objj_msgSend(objj_msgSend(CPSortDescriptor,"alloc"),"initWithKey:ascending:",_a,YES);
objj_msgSend(_b,"setSortDescriptorPrototype:",_c);
objj_msgSend(tableView,"addTableColumn:",_b);
}
}),new objj_method(sel_getUid("volumeDidChange:"),function(_d,_e,_f){
with(_d){
objj_msgSend(mediaPlayer,"setVolume:",objj_msgSend(volumeSlider,"doubleValue")/100);
}
}),new objj_method(sel_getUid("search:"),function(_10,_11,_12){
with(_10){
objj_msgSend(tableDataSource,"reloadLibraryWithQuery:",objj_msgSend(searchField,"objectValue"));
}
}),new objj_method(sel_getUid("didPlayPauseClick:"),function(_13,_14,_15){
with(_13){
objj_msgSend(mediaPlayer,"togglePlaying");
}
}),new objj_method(sel_getUid("didSelectItemToPlay:"),function(_16,_17,_18){
with(_16){
CPLog("Song did began play");
var _19=objj_msgSend(tableView,"selectedRow");
var _1a=objj_msgSend(tableDataSource,"valueForField:atRow:","Title",_19);
objj_msgSend(nowPlayingLabel,"setObjectValue:","Now Playing: "+_1a);
objj_msgSend(mediaPlayer,"playSong:",SERVER+"?q="+escape(objj_msgSend(searchField,"objectValue"))+"&i="+objj_msgSend(tableDataSource,"valueForField:atRow:","id",_19));
}
})]);
