@STATIC;1.0;I;21;Foundation/CPObject.jt;1514;
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
