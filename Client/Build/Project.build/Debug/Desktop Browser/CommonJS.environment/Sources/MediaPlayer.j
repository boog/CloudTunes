@STATIC;1.0;I;21;Foundation/CPObject.jt;2207;


objj_executeFile("Foundation/CPObject.j", NO);

{var the_class = objj_allocateClassPair(CPObject, "MediaPlayer"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("audioElement")]);
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
},["id"]), new objj_method(sel_getUid("playSong:"), function $MediaPlayer__playSong_(self, _cmd, urlResource)
{ with(self)
{
    audioElement.pause();


    audioElement.setAttribute('src', urlResource);
    audioElement.play();
    CPLog(audioElement.src);

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

