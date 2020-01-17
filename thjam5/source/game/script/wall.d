module game.script.wall;

import atelier, grimoire;
import game.scene;

package void loadWall(GrData data) {
    auto defWall = data.addUserType("Wall");

    data.addPrimitive(&_createWall, "createWall", ["x", "y", "hx", "hy"], [grInt, grInt, grInt, grInt], [defWall]);
    
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

private void _createWall(GrCall call) {
    auto wall = new Wall(Vec2i(call.getInt("x"), call.getInt("y")), Vec2i(call.getInt("hx"), call.getInt("hy")));
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