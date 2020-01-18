module game.script.time;


import grimoire;
import core.time;



package void loadTime(GrData data) {
    data.addPrimitive(&_time, "time", [], [], [grInt]);
}

private void _time(GrCall call) {
    call.setInt(cast(int) (MonoTime.currTime()-MonoTime.zero()).total!"usecs");
}