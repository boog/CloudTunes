#import <Foundation/Foundation.h>
#import "Controller.h"

enum
{
    LIST,
    PATH_AT_INDEX,
} APP_MODE;

int main (int argc, const char * argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    int appMode = LIST;
    int pathIndex = -1;
    NSString* searchQuery = @"";
    
    for (int i=1; i<argc; i++)
    {
        NSString* argument = [NSString stringWithUTF8String:argv[i]];
        if ([argument isEqualToString:@"-i"])
        {
            appMode = PATH_AT_INDEX;
            pathIndex = [[NSString stringWithUTF8String:argv[i+1]] intValue];
			i++; // Skip one;
        }
        else
        {
            searchQuery = [NSString stringWithUTF8String:argv[i]];
        }
    }
	
	Controller* cont = [[Controller alloc] init];
	if (appMode == LIST)
    {
        [cont startSearch:searchQuery];
    }
    else
    {
        [cont getPathAtIndex:pathIndex withSearchQuery:searchQuery];
    }

    [pool drain];
    return 0;
}
