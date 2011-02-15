
@import <Foundation/CPObject.j>

@implementation MediaPlayer : CPObject
{
    var audioElement;
	id delegate;
}

- (id)init
{
    if (self = [super init])
    {
        audioElement = document.createElement("audio");
		audioElement.addEventListener('ended', function() {[self didFinishPlaying];}, false);
		audioElement.addEventListener('timeupdate', function() {[self currentPositionDidUpdate];}, true);
    }
    return self;
}

-(void)setDelegate:(id)obj
{
	delegate = obj;
}

-(void)currentPositionDidUpdate
{
	if ([delegate respondsToSelector:@selector(mediaPlayer:currentPositionDidUpdate:)])
	{
		[delegate mediaPlayer:self currentPositionDidUpdate:[self currentPositionInSecs]];
	}
}

-(void)didFinishPlaying
{
	if ([self duration] == [self currentPositionInSecs])
	{
		CPLog(@"did finish playing!");
		if ([delegate respondsToSelector:@selector(mediaPlayer:didFinishPlaying:)])
		{
			[delegate mediaPlayer:self didFinishPlaying:audioElement['src']];
		}
	}
}

-(void)playSong:(CPString)urlResource
{
    audioElement.setAttribute('src', urlResource); 
	audioElement.load();
		
	// canplaythrough event is fired if browser thinks we've buffered enough to begin playing
	audioElement.addEventListener('canplaythrough', function() {
		audioElement.play();
	}, false);

    CPLog(@"did start playing " + audioElement.src);
}

-(void)setVolume:(int)ratio
{
    audioElement.volume = ratio;
}

-(void)seekToTime:(int)timeInSecs
{
    audioElement.currentTime = timeInSecs;
}

-(boolean)isPlaying
{
    return !audioElement.paused;
}

-(void)pause
{
    audioElement.pause();
}

-(void)play
{
    audioElement.play();
}

-(void)togglePlaying
{
    if ([self isPlaying])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

-(int)duration
{
    return audioElement.duration;
}

-(int)currentPositionInSecs
{
    return audioElement.currentTime;
}



@end
