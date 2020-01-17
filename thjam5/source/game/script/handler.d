module game.script.handler;

import std.conv: to;
import std.stdio: writeln;
import grimoire;
import game.script.math, game.script.tween, game.script.wall;

private {
    GrData _data;
    GrEngine _engine;
    GrBytecode _bytecode;
    GrError _error;
}

private void loadScriptDefinitions(GrData data) {
    loadMath(data);
    loadTween(data);
    loadWall(data);
}

/// Compile and run a script file.
void loadScript(string filePath) {
    _data = new GrData;
    grLoadStdLibrary(_data);
    loadScriptDefinitions(_data);
    GrCompiler compiler = new GrCompiler(_data);
    if(!compiler.compileFile(_bytecode, filePath)) {
        _error = compiler.getError();
        printError(_error);
        throw new Exception("Compilation aborted...");
    }
    writeln(grDump(_data, _bytecode));
    _engine = new GrEngine;
    _engine.load(_data, _bytecode);
    _engine.spawn();
}

/// Run a script step.
void runScript() {
    if(_engine.hasCoroutines)
        _engine.process();
    if(_engine.isPanicking) {
        throw new Exception("Panic: " ~ to!string(_engine.panicMessage));
    }
}

/// Format compilation problems and throw an exception with them.
void printError(GrError error) {
    string report;
    
    report ~= "\033[0;91merror";
    //report ~= "\033[0;93mwarning";

    //Error report
    report ~= "\033[37;1m: " ~ error.message ~ "\033[0m\n";

    //File path
    string lineNumber = to!string(error.line) ~ "| ";
    foreach(x; 1 .. lineNumber.length)
        report ~= " ";

    report ~= "\033[0;36m->\033[0m "
        ~ error.filePath
        ~ "(" ~ to!string(error.line)
        ~ "," ~ to!string(error.column)
        ~ ")\n";
    
    report ~= "\033[0;36m";

    foreach(x; 1 .. lineNumber.length)
        report ~= " ";
    report ~= "\033[0;36m|\n";

    //Script snippet
    report ~= " " ~ lineNumber;
    report ~= "\033[1;34m" ~ error.lineText ~ "\033[0;36m\n";

    //Red underline
    foreach(x; 1 .. lineNumber.length)
        report ~= " ";
    report ~= "\033[0;36m|";
    foreach(x; 0 .. error.column)
        report ~= " ";

    report ~= "\033[1;31m"; //Red color
    //report ~= "\033[1;93m"; //Orange color

    foreach(x; 0 .. error.textLength)
        report ~= "^";
    
    //Error description
    report ~= "\033[0;31m"; //Red color
    //report ~= "\033[0;93m"; //Orange color

    if(error.info.length)
        report ~= "  " ~ error.info;
    report ~= "\n";

    foreach(x; 1 .. lineNumber.length)
        report ~= " ";
    report ~= "\033[0;36m|\033[0m\n";
    
    writeln(report);
}
