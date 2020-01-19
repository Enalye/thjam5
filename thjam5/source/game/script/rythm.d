module game.script.rythm;

import atelier, grimoire;

import std.conv;
import game.scene.rythm;
import game.scene.world;

package void loadRythm(GrData data) {
    data.addPrimitive(&_getFirstBeatOffset, "getFirstBeatOffset", [], [], [grFloat]);
    data.addPrimitive(&_getSongPositionBeats, "getSongPositionBeats", [], [], [grInt]);
    data.addPrimitive(&_playDrum, "playDrum", [], [], []);
    data.addPrimitive(&_loadMusic, "loadMusic", ["name", "sec"], [grString, grInt]);
}

private void _loadMusic(GrCall call) {
    RythmHandler rythmHandler = getRythmHandler();
    rythmHandler.load(to!string(call.getString("name")), call.getInt("sec"));
}

private void _getFirstBeatOffset(GrCall call) {
    RythmHandler rythmHandler = getRythmHandler();
    call.setFloat(rythmHandler.firstBeatOffset);
}

private void _getSongPositionBeats(GrCall call) {
    RythmHandler rythmHandler = getRythmHandler();
    call.setInt(rythmHandler.songPositionBeats);
}

private void _playDrum(GrCall call) {
    RythmHandler rythmHandler = getRythmHandler();
    rythmHandler.playDebugSound();
}