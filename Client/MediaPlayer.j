
@import <Foundation/CPObject.j>

@implementation MediaPlayer : CPObject
{
    var audioElement;
}

- (id)init
{
    if (self = [super init])
    {
        audioElement = document.createElement("audio");
    }
    return self;
}

-(void)playSong:(CPString)urlResource
{
    audioElement.pause();
    //audioElement.load(urlResource);
    //audioElement.setAttribute('src', 'http://emma.baileycarlson.net/test.mp3'); 
    audioElement.setAttribute('src', urlResource); 
    audioElement.play();
    CPLog(audioElement.src);
    //document.write(audioTag);
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
