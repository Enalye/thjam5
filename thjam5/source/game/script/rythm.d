module game.script.rythm;

import atelier, grimoire;

import game.scene.rythm;
import game.scene.world;

package void loadRythm(GrData data) {
    data.addPrimitive(&_getFirstBeatOffset, "getFirstBeatOffset", [], [], [grFloat]);
    data.addPrimitive(&_getSongPositionBeats, "getSongPositionBeats", [], [], [grInt]);
    data.addPrimitive(&_playDrum, "playDrum", [], [], []);
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