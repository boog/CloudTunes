@STATIC;1.0;I;21;Foundation/CPObject.jt;1862;
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
