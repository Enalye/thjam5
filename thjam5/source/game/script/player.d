module game.script.player;

import atelier, grimoire;
import std.format;
import game.scene;

package void loadPlayer(GrData data) {
    auto defPlayer = data.addUserType("Player");
	grPlayer = defPlayer;
    data.addPrimitive(&_getPlayer, "getPlayer", [], [], [defPlayer]);
    
    data.addPrimitive(&_setPlayerPosition, "setPosition", ["player", "x", "y"], [defPlayer, grInt, grInt]);
    data.addPrimitive(&_getPlayerPosition, "getPosition", ["player"], [defPlayer], [grInt, grInt]);
    data.addPrimitive(&_getPlayerPositionX, "getPositionX", ["player"], [defPlayer], [grInt]);
    data.addPrimitive(&_getPlayerPositionY, "getPositionY", ["player"], [defPlayer], [grInt]);

    data.addPrimitive(&_setPlayerHitbox, "setHitbox", ["player", "x", "y"], [defPlayer, grInt, grInt]);
    data.addPrimitive(&_getPlayerHitbox, "getHitbox", ["player"], [defPlayer], [grInt, grInt]);
    data.addPrimitive(&_getPlayerHitboxX, "getHitboxX", ["player"], [defPlayer], [grInt]);
    data.addPrimitive(&_getPlayerHitboxY, "getHitboxY", ["player"], [defPlayer], [grInt]);
    data.addPrimitive(&_KillPlayer, "killp", ["player"], [defPlayer]);
    data.addPrimitive(&_DamagePlayer, "damage", ["player", "amount"], [defPlayer, grFloat]);
}

GrType grPlayer;

private void _getPlayer(GrCall call) {
    call.setUserData!Player(getPlayer());
}

private void _setPlayerPosition(GrCall call) {
    Player player = call.getUserData!Player("player");
    player.position = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getPlayerPosition(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.position.x);
    call.setInt(player.position.y);
}

private void _getPlayerPositionX(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.position.x);
}

private void _getPlayerPositionY(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.position.y);
}

private void _setPlayerHitbox(GrCall call) {
    Player player = call.getUserData!Player("player");
    player.hitbox = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getPlayerHitbox(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.hitbox.x);
    call.setInt(player.hitbox.y);
}

private void _getPlayerHitboxX(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.hitbox.x);
}

private void _getPlayerHitboxY(GrCall call) {
    Player player = call.getUserData!Player("player");
    call.setInt(player.hitbox.y);
}

private void _KillPlayer(GrCall call) {
    Player player = call.getUserData!Player("player");
	writeln("Player killed");
}

private void _DamagePlayer(GrCall call) {
    Player player = call.getUserData!Player("player");
	writeln(format!"Player taking %s damage"(call.getFloat("damage")));
}