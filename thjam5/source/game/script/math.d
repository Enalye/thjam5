module game.script.math;

import std.random;
import std.algorithm.comparison: clamp;
import atelier, grimoire;

package void loadMath(GrData data) {
    data.addPrimitive(&_clamp, "clamp", ["v", "min", "max"], [grFloat, grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_random01, "random", [], [], [grFloat]);
    data.addPrimitive(&_randomf, "random", ["v1", "v2"], [grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_randomi, "random", ["v1", "v2"], [grInt, grInt], [grInt]);
    data.addPrimitive(&_cos, "cos", ["v"], [grFloat], [grFloat]);
    data.addPrimitive(&_sin, "sin", ["v"], [grFloat], [grFloat]);
    data.addPrimitive(&_lerp, "lerp", ["a", "b", "t"], [grFloat, grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_rlerp, "rlerp", ["a", "b", "v"], [grFloat, grFloat, grFloat], [grFloat]);
}

private void _clamp(GrCall call) {
    call.setFloat(clamp(call.getFloat("v"), call.getFloat("min"), call.getFloat("max")));
}

private void _random01(GrCall call) {
    call.setFloat(uniform01());
}

private void _randomf(GrCall call) {
    call.setFloat(uniform!"[]"(call.getFloat("v1"), call.getFloat("v2")));
}

private void _randomi(GrCall call) {
    call.setInt(uniform!"[]"(call.getInt("v1"), call.getInt("v2")));
}

private void _cos(GrCall call) {
    call.setFloat(cos(call.getFloat("v")));
}

private void _sin(GrCall call) {
    call.setFloat(sin(call.getFloat("v")));
}

private void _lerp(GrCall call) {
    call.setFloat(lerp(call.getFloat("a"), call.getFloat("b"), call.getFloat("t")));
}

private void _rlerp(GrCall call) {
    call.setFloat(rlerp(call.getFloat("a"), call.getFloat("b"), call.getFloat("v")));
}