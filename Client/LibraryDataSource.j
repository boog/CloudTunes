
@import <Foundation/CPObject.j>

@implementation LibraryDataSource : CPObject
{
    CPString jsonData;
    CPArray libraryList;
    CPArray filteredList;
    CPTableView tableView;
}

- (void)reloadLibraryWithQuery:(CPString)query
{
    jsonData = @"";
    var request = [[CPURLRequest alloc] initWithURL:SERVER + "?q=" + escape(query)];
    [request setHTTPMethod:@"GET"];
    
    var urlConnection = [CPURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];
}

- (CPString)valueForField:(CPString)field atRow:(int)rowIndex
{
    var item = [libraryList objectAtIndex:rowIndex];
    return [item objectForKey:field]; //  item[field];
}

/* URLConnectionDelegate methods */

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    jsonData += data;
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
    // Deserialize JSON data of library audio files
    var jsonObject = [jsonData objectFromJSON];
    libraryList = [CPArray array];
    for (i=0; i<jsonObject.length; i++)
    {
        var testDictionary = [CPDictionary dictionaryWithJSObject:jsonObject[i] recursively:YES];
        [libraryList addObject:testDictionary];
    }
    // Reload table view data
    [tableView reloadData];
}

/* TableViewDataSourceDelegate methods */
-(int)numberOfRowsInTableView:(id)sender
{
    return [libraryList count];
}

-(id)tableView:(id)sender objectValueForTableColumn:(CPTableColumn)col row:(int)rowIndex
{
    var colIdentifier = [col identifier];
    return [self valueForField:colIdentifier atRow:rowIndex];
}

-(void)tableView:(CPTableView)tv sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    CPLog(@"Sorting with descriptor: %@", [tv sortDescriptors]);
    //[libraryList sortUsingDescriptors:[tv sortDescriptors]];
    //[tv reloadData];
}



@end
