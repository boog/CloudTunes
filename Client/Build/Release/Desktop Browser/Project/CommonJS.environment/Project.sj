@STATIC;1.0;p;15;AppController.jt;3333;@STATIC;1.0;I;21;Foundation/CPObject.ji;19;LibraryDataSource.ji;13;MediaPlayer.jt;3246;
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
p;19;LibraryDataSource.jt;1907;@STATIC;1.0;I;21;Foundation/CPObject.jt;1862;
objj_executeFile("Foundation/CPObject.j",NO);
var _1=objj_allocateClassPair(CPObject,"LibraryDataSource"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("jsonData"),new objj_ivar("libraryList"),new objj_ivar("filteredList"),new objj_ivar("tableView")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("reloadLibraryWithQuery:"),function(_3,_4,_5){
with(_3){
jsonData="";
var _6=objj_msgSend(objj_msgSend(CPURLRequest,"alloc"),"initWithURL:",SERVER+"?q="+escape(_5));
objj_msgSend(_6,"setHTTPMethod:","GET");
var _7=objj_msgSend(CPURLConnection,"connectionWithRequest:delegate:",_6,_3);
objj_msgSend(_7,"start");
}
}),new objj_method(sel_getUid("valueForField:atRow:"),function(_8,_9,_a,_b){
with(_8){
var _c=objj_msgSend(libraryList,"objectAtIndex:",_b);
return objj_msgSend(_c,"objectForKey:",_a);
}
}),new objj_method(sel_getUid("connection:didReceiveData:"),function(_d,_e,_f,_10){
with(_d){
jsonData+=_10;
}
}),new objj_method(sel_getUid("connectionDidFinishLoading:"),function(_11,_12,_13){
with(_11){
var _14=objj_msgSend(jsonData,"objectFromJSON");
libraryList=objj_msgSend(CPArray,"array");
for(i=0;i<_14.length;i++){
var _15=objj_msgSend(CPDictionary,"dictionaryWithJSObject:recursively:",_14[i],YES);
objj_msgSend(libraryList,"addObject:",_15);
}
objj_msgSend(tableView,"reloadData");
}
}),new objj_method(sel_getUid("numberOfRowsInTableView:"),function(_16,_17,_18){
with(_16){
return objj_msgSend(libraryList,"count");
}
}),new objj_method(sel_getUid("tableView:objectValueForTableColumn:row:"),function(_19,_1a,_1b,col,_1c){
with(_19){
var _1d=objj_msgSend(col,"identifier");
return objj_msgSend(_19,"valueForField:atRow:",_1d,_1c);
}
}),new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"),function(_1e,_1f,tv,_20){
with(_1e){
CPLog("Sorting with descriptor: %@",objj_msgSend(tv,"sortDescriptors"));
}
})]);
p;6;main.jt;267;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;15;AppController.jt;181;
objj_executeFile("Foundation/Foundation.j",NO);
objj_executeFile("AppKit/AppKit.j",NO);
objj_executeFile("AppController.j",YES);
main=function(_1,_2){
CPApplicationMain(_1,_2);
};
p;13;MediaPlayer.jt;1559;@STATIC;1.0;I;21;Foundation/CPObject.jt;1514;
objj_executeFile("Foundation/CPObject.j",NO);
var _1=objj_allocateClassPair(CPObject,"MediaPlayer"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("audioElement")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("init"),function(_3,_4){
with(_3){
if(_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("MediaPlayer").super_class},"init")){
audioElement=document.createElement("audio");
}
return _3;
}
}),new objj_method(sel_getUid("playSong:"),function(_5,_6,_7){
with(_5){
audioElement.pause();
audioElement.setAttribute("src",_7);
audioElement.play();
CPLog(audioElement.src);
}
}),new objj_method(sel_getUid("setVolume:"),function(_8,_9,_a){
with(_8){
audioElement.volume=_a;
}
}),new objj_method(sel_getUid("seekToTime:"),function(_b,_c,_d){
with(_b){
audioElement.currentTime=_d;
}
}),new objj_method(sel_getUid("isPlaying"),function(_e,_f){
with(_e){
return !audioElement.paused;
}
}),new objj_method(sel_getUid("pause"),function(_10,_11){
with(_10){
audioElement.pause();
}
}),new objj_method(sel_getUid("play"),function(_12,_13){
with(_12){
audioElement.play();
}
}),new objj_method(sel_getUid("togglePlaying"),function(_14,_15){
with(_14){
if(objj_msgSend(_14,"isPlaying")){
objj_msgSend(_14,"pause");
}else{
objj_msgSend(_14,"play");
}
}
}),new objj_method(sel_getUid("duration"),function(_16,_17){
with(_16){
return audioElement.duration;
}
}),new objj_method(sel_getUid("currentPositionInSecs"),function(_18,_19){
with(_18){
return audioElement.currentTime;
}
})]);
e;