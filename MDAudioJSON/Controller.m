#import "Controller.h"

@interface Controller (PrivateMethods)

- (void)startSearch:(SEL)callback withQuery:(NSString*)userEnteredString;
- (NSString*)getAttribute:(NSString*)attrName forMDItem:(MDItemRef)item;

@end


@implementation Controller


- (id)init
{
	if (self = [super init])
	{
		isFinished = NO;
	}
	return self;
}

- (void)startSearch:(NSString*)searchQuery
{
	[self startSearch:@selector(updateData:) withQuery:searchQuery];
	while (!isFinished) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
}

- (void)getPathAtIndex:(int)index withSearchQuery:(NSString*)searchQuery
{
    requestItemIndex = index;
    [self startSearch:@selector(printPathFromResults:) withQuery:searchQuery];
	while (!isFinished) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
}

- (void)startSearch:(SEL)callback withQuery:(NSString*)userEnteredString
{
	/* Build up the query string */
    NSString *queryString;
    //NSString *userEnteredString = @"";
	
    //userEnteredString = [searchField stringValue];
	
    if (query){
		/* Stop listening to the notifications */
        [[NSNotificationCenter defaultCenter] removeObserver:self];
		
		/* Release the old query */
		MDQueryStop(query);
        CFRelease(query);
        query = NULL;
    }
	
	// Set up a query string to search for all audio file types
    queryString = [NSString stringWithFormat:@"(kMDItemContentType == public.mpeg-4-audio || kMDItemContentType == public.mp3) && (*='%@*'wcd || kMDItemTextContent = '%@*'cd)",userEnteredString,userEnteredString];
    query       = MDQueryCreate(kCFAllocatorDefault,(CFStringRef)queryString,NULL,(CFArrayRef)[NSArray arrayWithObjects:(id)kMDItemAuthors, kMDItemAlbum, kMDItemAudioTrackNumber,nil]);
	MDQuerySetSearchScope(query, (CFArrayRef)[NSArray arrayWithObjects:(id)kMDQueryScopeHome,nil],0);
	// This sort block allows us to sort the query by list attribute types
	MDQuerySetSortComparatorBlock(query, ^CFComparisonResult(const CFTypeRef attrs2[], const CFTypeRef attrs1[]){
		if (*attrs1 != NULL && *attrs2 != NULL)
		{
			CFTypeID type = CFGetTypeID(*attrs1);
			if (CFArrayGetTypeID() == type)
			{
				CFStringRef str1 = [*attrs1 objectAtIndex:0];
				CFStringRef str2 = [*attrs2 objectAtIndex:0];
				return CFStringCompare(str2, str1,0);
			}
			else if (CFStringGetTypeID() == type)
			{
				return CFStringCompare(*attrs2, *attrs1, 0);	
			}
			else {
				NSLog(@"Unknown type");
			}
		}
		return kCFCompareEqualTo;
	});
	
	if (query){
		/* Set up notifications */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:(NSString*)kMDQueryDidFinishNotification object:(id)query];
    }
	
    MDQueryExecute(query, kMDQueryWantsUpdates);
}

- (void)updateData:(NSNotification *)notification
{
	int numResults = MDQueryGetResultCount(query);
	
	NSMutableArray* resultsArr = [[NSMutableArray alloc] init];
	for (int i=0; i<numResults; i++)
	{
		MDItemRef item = (MDItemRef)MDQueryGetResultAtIndex(query, i);
		NSString* title = [self getAttribute:@"kMDItemTitle" forMDItem:item];
		NSString* artist = [self getAttribute:@"kMDItemAuthors" forMDItem:item];
		NSString* album = [self getAttribute:@"kMDItemAlbum" forMDItem:item];
        //NSString* identifier = [self getAttribute:@"kMDItemIdentifier" forMDItem:item];
		if (title.length > 0 && artist.length > 0)
		{
			NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
			[resultDict setObject:title forKey:@"Title"];
			[resultDict setObject:artist forKey:@"Artist"];
			[resultDict setObject:album forKey:@"Album"];
			[resultDict setObject:[NSNumber numberWithInt:i] forKey:@"id"];
			[resultsArr addObject:resultDict];
		}
	}
	
	printf("%s",[[resultsArr yajl_JSONString] UTF8String]);
	isFinished = YES;
}

- (void)printPathFromResults:(NSNotification*)notification
{
	
    MDItemRef item = (MDItemRef)MDQueryGetResultAtIndex(query, requestItemIndex);
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    NSString* filename = [self getAttribute:@"kMDItemPath" forMDItem:item];
    if (filename.length > 0 )
    {
        [resultDict setObject:filename forKey:@"path"];
    }
	
	printf("%s",[[resultDict yajl_JSONString] UTF8String]);
	isFinished = YES;
}

- (NSString*)getAttribute:(NSString*)attrName forMDItem:(MDItemRef)item
{
	NSObject* object = (NSObject*)MDItemCopyAttribute(item, attrName);
	// Check if attribute is a list
	if ([object respondsToSelector:@selector(objectAtIndex:)])
	{
		// If list just get the first item (for our purposes with Artist)
		// might be better to join them as comma delimited
		object = [object objectAtIndex:0];
	}
	//[object autorelease];
	return object == nil ? @"" : object;
}

@end
