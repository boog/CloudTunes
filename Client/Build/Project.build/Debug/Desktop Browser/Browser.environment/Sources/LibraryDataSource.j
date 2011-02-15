@STATIC;1.0;I;21;Foundation/CPObject.jt;2858;


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

