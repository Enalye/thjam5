module game.script.projectile;

import game.scene.projectile;
import game.scene.world;
import atelier, grimoire;
import game.scene;

package void loadProjectile(GrData data) {
    auto defProjectile = data.addUserType("Projectile");
	grProjectile = defProjectile;
    data.addPrimitive(&_createProjectile, "createProjectile", ["x", "y", "hx", "hy", "colmode","evPlayer"], [grInt, grInt, grInt, grInt, grInt, grString], [defProjectile]);
    /*
    data.addPrimitive(&_setWallPosition, "setPosition", ["wall", "x", "y"], [defWall, grInt, grInt]);
    data.addPrimitive(&_getWallPosition, "getPosition", ["wall"], [defWall], [grInt, grInt]);
    data.addPrimitive(&_getWallPositionX, "getPositionX", ["wall"], [defWall], [grInt]);
    data.addPrimitive(&_getWallPositionY, "getPositionY", ["wall"], [defWall], [grInt]);

    data.addPrimitive(&_setWallHitbox, "setHitbox", ["wall", "x", "y"], [defWall, grInt, grInt]);
    data.addPrimitive(&_getWallHitbox, "getHitbox", ["wall"], [defWall], [grInt, grInt]);
    data.addPrimitive(&_getWallHitboxX, "getHitboxX", ["wall"], [defWall], [grInt]);
    data.addPrimitive(&_getWallHitboxY, "getHitboxY", ["wall"], [defWall], [grInt]);
	*/

    data.addPrimitive(&_moveProjectile, "move", ["projectile", "x", "y"], [defProjectile, grFloat, grFloat]);
    data.addPrimitive(&_moveProjectileTo, "moveTo", ["projectile", "x", "y"], [defProjectile, grFloat, grFloat]);


    data.addPrimitive(&_destroyProjectile, "destroy", ["projectile"], [defProjectile]);
}

GrType grProjectile;

private void _createProjectile(GrCall call) {
    auto proj = new Projectile(
		Vec2i(call.getInt("x"), call.getInt("y")), 
		Vec2i(call.getInt("hx"), call.getInt("hy")),
		call.getInt("colmode") == 0 ? CollisionModel.Hitbox: CollisionModel.Radius,
		"", call.getString("evPlayer"), ""
	);
    spawnProjectile(proj);
    call.setUserData!Projectile(proj);
}
/*
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
}*/

private void _moveProjectile(GrCall call) {
    Projectile projectile = call.getUserData!Projectile("projectile");
    projectile.move(Vec2f(call.getFloat("x"), call.getFloat("y")));
}

private void _destroyProjectile(GrCall call) {
    Projectile projectile = call.getUserData!Projectile("projectile");
	projectile.toDelete = true;
}

private void _moveProjectileTo(GrCall call) {
    Projectile projectile = call.getUserData!Projectile("projectile");
    projectile.move(Vec2f(call.getFloat("x") - projectile.position.x, call.getFloat("y") - projectile.position.y));
}