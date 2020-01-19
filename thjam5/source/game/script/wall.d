module game.script.wall;

import atelier, grimoire;
import std.conv;
import game.scene;
import game.scene.background;

package void loadWall(GrData data) {
    auto defWall = data.addUserType("Wall");

    data.addPrimitive(&_loadBackground,
                      "loadBackground",
                      ["background", "boss1", "boss2"],
                      [grString, grString, grString]);

    data.addPrimitive(&_createWall, "createWall",
                      ["fileName", "x", "y", "hx", "hy"],
                      [grString, grInt, grInt, grInt, grInt], [defWall]);
    
    data.addPrimitive(&_setWallPosition, "setPosition", ["wall", "x", "y"], [defWall, grInt, grInt]);
    data.addPrimitive(&_getWallPosition, "getPosition", ["wall"], [defWall], [grInt, grInt]);
    data.addPrimitive(&_getWallPositionX, "getPositionX", ["wall"], [defWall], [grInt]);
    data.addPrimitive(&_getWallPositionY, "getPositionY", ["wall"], [defWall], [grInt]);

    data.addPrimitive(&_setWallHitbox, "setHitbox", ["wall", "x", "y"], [defWall, grInt, grInt]);
    data.addPrimitive(&_getWallHitbox, "getHitbox", ["wall"], [defWall], [grInt, grInt]);
    data.addPrimitive(&_getWallHitboxX, "getHitboxX", ["wall"], [defWall], [grInt]);
    data.addPrimitive(&_getWallHitboxY, "getHitboxY", ["wall"], [defWall], [grInt]);

    data.addPrimitive(&_moveWall, "move", ["wall", "x", "y"], [defWall, grFloat, grFloat]);
    data.addPrimitive(&_moveWallTo, "moveTo", ["wall", "x", "y"], [defWall, grFloat, grFloat]);
}

private void _loadBackground(GrCall call) {
    Background background = getBackground();
    background.load(to!string(call.getString("background")),
                    to!string(call.getString("boss1")),
                    to!string(call.getString("boss2")));
}

private void _createWall(GrCall call) {
    auto wall = new Wall(to!string(call.getString("fileName")),
                         Vec2i(call.getInt("x"),
                               call.getInt("y")),
                         Vec2i(call.getInt("hx"),
                               call.getInt("hy")));
    spawnSolid(wall);
    call.setUserData!Wall(wall);
}

private void _setWallPosition(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    wall.position = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getWallPosition(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.position.x);
    call.setInt(wall.position.y);
}

private void _getWallPositionX(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.position.x);
}

private void _getWallPositionY(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.position.y);
}

private void _setWallHitbox(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    wall.hitbox = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getWallHitbox(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.hitbox.x);
    call.setInt(wall.hitbox.y);
}

private void _getWallHitboxX(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.hitbox.x);
}

private void _getWallHitboxY(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    call.setInt(wall.hitbox.y);
}

private void _moveWall(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    wall.move(call.getFloat("x"), call.getFloat("y"));
}

private void _moveWallTo(GrCall call) {
    Wall wall = call.getUserData!Wall("wall");
    wall.move(call.getFloat("x")-wall.position.x, call.getFloat("y")-wall.position.y);
}