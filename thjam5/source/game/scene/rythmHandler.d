module game.scene.rythm;

import atelier;
import std.datetime.stopwatch, std.stdio;
import game.scene.world;

class RythmHandler {
    Music     _music;
    Sound     _drum;
    StopWatch _clock;

    float _durationSec;
    float _secPerBeat;
    float _songPositionSec;
    float _firstBeatOffset;
    float _loopOffset;
    float _loopPositionRatio;

    int _songBpm;
    int _completedLoops;
    int _songPositionBeats;
    int _loopPositionBeats;
    int _beatsPerLoop;

    @property {
        float firstBeatOffset() { return _firstBeatOffset; }
        int songPositionBeats() { return _songPositionBeats; }
    }

    void load(string fileName, int secs) {
        start(fileName, 160, secs, 1f, 10f);
    }

    void start(string fileName,
               int    bpm,
               float  durationSec,
               float  firstBeatOffset,
               float  loopOffset) {
        _music           = fetch!Music(fileName);
        _drum            = fetch!Sound("drum");
        _songBpm         = bpm;
        _durationSec     = durationSec;
        _secPerBeat      = 60f / _songBpm;

        _firstBeatOffset = firstBeatOffset;
        _loopOffset      = loopOffset;
        _beatsPerLoop    = cast(int)(durationSec / _secPerBeat);

        _songPositionSec   = 0;
        _songPositionBeats = 0;

        _music.fadeIn(10f);
        _clock.start();
    }

    void update() {
        if(_music is null) {
            return;
        }

        _songPositionSec   = (_clock.peek.total!"msecs" / 1000f) - _firstBeatOffset;
        _songPositionBeats = cast(int)(_songPositionSec / _secPerBeat);

        const int nextLoopBeats = (_completedLoops + 1) * _beatsPerLoop;

        if(_songPositionBeats >= nextLoopBeats) {
            _loopPositionBeats = _songPositionBeats - nextLoopBeats;
            _clock.reset();
            ++_completedLoops;
        }

        _loopPositionRatio = _loopPositionBeats / _beatsPerLoop;

        if(_songPositionSec >= _durationSec) {
            goToNextLevel();
        }
    }

    void playDebugSound() {
        _drum.play();
    }
}