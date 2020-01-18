module game.rythm;

import atelier;
import std.datetime.stopwatch;

class RythmHandler {
    Music     _music;
    StopWatch _clock;

    float _durationSec;
    float _secPerBeat;
    float _songPositionSec;
    float _songPositionBeats;
    float _firstBeatOffset;
    float _loopOffset;
    float _beatsPerLoop;
    float _loopPositionBeats;
    float _loopPositionRatio;

    int _songBpm;
    int _completedLoops;

    void start(string fileName,
               int    bpm,
               float  durationSec,
               float  firstBeatOffset,
               float  loopOffset) {
        _music           = fetch!Music(fileName);
        _songBpm         = bpm;
        _durationSec     = durationSec;
        _secPerBeat      = 60f / _songBpm;
        _firstBeatOffset = firstBeatOffset;
        _loopOffset      = loopOffset;
        _beatsPerLoop    = durationSec / _secPerBeat;

        _songPositionSec   = 0;
        _songPositionBeats = 0;

        _music.isLooped = true;
        _music.play();
        _clock.start();
    }

    void update() {
        _songPositionSec   = _clock.peek.total!"seconds" - _firstBeatOffset;
        _songPositionBeats = _songPositionSec / _secPerBeat;

        const float nextLoopBeats = (_completedLoops + 1) * _beatsPerLoop;

        if(_songPositionBeats >= nextLoopBeats) {
            _loopPositionBeats = _songPositionBeats - nextLoopBeats;
            _clock.reset();
            ++_completedLoops;
        }

        _loopPositionRatio = _loopPositionBeats / _beatsPerLoop;
    }
}