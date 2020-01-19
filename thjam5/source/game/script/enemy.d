module game.script.enemy;

import atelier, grimoire;
import std.format; import std.stdio;
import game.scene;
import game.scene.enemy;
import game.scene.world;

package void loadEnemy(GrData data) {
    auto defEnemy = data.addUserType("Enemy");
    grEnemy = defEnemy;

	data.addPrimitive(&_grSpawnEnemy, "spawnEnemy", ["name", "x", "y"], [grString, grInt, grInt], [defEnemy]);
    data.addPrimitive(&_setEnemyPosition, "setPosition", ["enemy", "x", "y"], [defEnemy, grInt, grInt]);
    data.addPrimitive(&_getEnemyPosition, "getPosition", ["enemy"], [defEnemy], [grInt, grInt]);
    data.addPrimitive(&_getEnemyPositionX, "getPositionX", ["enemy"], [defEnemy], [grInt]);
    data.addPrimitive(&_getEnemyPositionY, "getPositionY", ["enemy"], [defEnemy], [grInt]);
    data.addPrimitive(&_setEnemySpeed, "setSpeed", ["enemy", "speedX", "speedY"], [defEnemy, grFloat, grFloat]);
    data.addPrimitive(&_setEnemyHitbox, "setHitbox", ["enemy", "x", "y"], [defEnemy, grInt, grInt]);
    data.addPrimitive(&_getEnemyHitbox, "getHitbox", ["enemy"], [defEnemy], [grInt, grInt]);
    data.addPrimitive(&_getEnemyHitboxX, "getHitboxX", ["enemy"], [defEnemy], [grInt]);
    data.addPrimitive(&_getEnemyHitboxY, "getHitboxY", ["enemy"], [defEnemy], [grInt]);
    data.addPrimitive(&_isEnemyGrounded, "isGrounded", ["enemy"], [defEnemy], [grBool]);
    data.addPrimitive(&_killEnemy, "killp", ["enemy"], [defEnemy]);
    data.addPrimitive(&_damageEnemy, "damage", ["enemy", "amount"], [defEnemy, grFloat]);
}

GrType grEnemy;

private void _grSpawnEnemy(GrCall call) {
	string name = "";//to!string(call.getString("name"));
	const int x = call.getInt("x");
	const int y = call.getInt("y");

	Enemy enemy = new Enemy(name, Vec2i(x, y));
    spawnActor(enemy);
	call.setUserData!Enemy(enemy);
}

private void _setEnemyPosition(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    enemy.position = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getEnemyPosition(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.position.x);
    call.setInt(enemy.position.y);
}

private void _getEnemyPositionX(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.position.x);
}

private void _getEnemyPositionY(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.position.y);
}

private void _setEnemySpeed(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    enemy.speed = Vec2f(call.getFloat("speedX"), call.getFloat("speedY"));
}

private void _setEnemyHitbox(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    enemy.hitbox = Vec2i(call.getInt("x"), call.getInt("y"));
}

private void _getEnemyHitbox(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.hitbox.x);
    call.setInt(enemy.hitbox.y);
}

private void _getEnemyHitboxX(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.hitbox.x);
}

private void _getEnemyHitboxY(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setInt(enemy.hitbox.y);
}

private void _isEnemyGrounded(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
    call.setBool(enemy.onGround);
}

private void _killEnemy(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
	writeln("Enemy killed");
}

private void _damageEnemy(GrCall call) {
    Enemy enemy = call.getUserData!Enemy("enemy");
	writeln(format!"Enemy taking %s damage"(call.getFloat("damage")));
}