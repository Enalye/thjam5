module game.scene.world;

import std.file, std.path, std.typecons, std.algorithm.comparison;
import atelier;

import
game.scene.actor,
game.scene.solid,
game.scene.player,
game.scene.wall,
game.scene.projectile,
game.scene.enemy;

import game.script;

/// Levels
immutable string[] levelsName = ["level1.gr"];

/// The entire world.
final class World: GuiElementCanvas {
    /// Ctor
    this() {
        size(screenSize);
        initWorld();
    }

    override void update(float deltaTime) {
        updateWorld(canvas, deltaTime);
    }

    override void draw() {
        drawWorld();
    }
}

private {
    ActorArray      _actors;
    SolidArray      _solids;
    ProjectileArray _projectiles;
    EnemyArray      _enemies;
    Player          _player;
}

ActorArray getWorldActors() {
    return _actors;
}

SolidArray getWorldSolids() {
    return _solids;
}

EnemyArray getWorldEnemies() {
    return _enemies;
}

private void initWorld() {
    _actors      = new ActorArray;
    _solids      = new SolidArray;
    _enemies     = new EnemyArray;
    _projectiles = new ProjectileArray;

    _actors.push(_player = new Player);
    _solids.push(new Wall(Vec2i(0, -50), Vec2i(300, 50)));
    _solids.push(new Wall(Vec2i(-40, 80), Vec2i(30, 200)));

	const string filePath = buildNormalizedPath("assets", "data", "scripts", levelsName[0]);
    if(!exists(filePath))
        throw new Exception(filePath ~ " do not exist.");
    loadScript(filePath);
}

private void updateWorld(Canvas canvas, float deltaTime) {
    foreach(Solid solid; _solids)
        solid.update(deltaTime);

    foreach(Actor actor; _actors)
        actor.update(deltaTime);

    foreach(Enemy enemy, uint enemyIdx; _enemies) {
        enemy.update(deltaTime);
        if(enemy.toDelete) {
            _enemies.markForRemoval(enemyIdx);
        }
    }

    foreach(Projectile proj, uint pos; _projectiles)
    {
		proj.collidedThisFrame = false;
		if(proj.setForDeletion) {
			_projectiles.markForRemoval(pos);
		}
	}
	_projectiles.sweepMarkedData();

    canvas.size = screenSize;
    canvas.position = _player.getPosition2d();

    runScript();
}

private void drawWorld() {
    const Color c1 = Color(0.74f, 0.74f, 0.74f);
    const Color c2 = Color(0.49f, 0.49f, 0.49f);
    int x, y, i;
    for(y = 0; y < screenHeight; y += 32) {
        for(x = 0; x < screenWidth; x += 32) {
            drawFilledRect(Vec2f(x, y) - centerScreen, Vec2f.one * 32f, i % 2 > 0 ? c1 : c2);
            i ++;
        }
        i ++;
    }
    drawRect(Vec2f.zero - centerScreen, Vec2f(x, y), Color.black);
    drawRect(-Vec2f.one - centerScreen, Vec2f(x, y) + 2f, Color.black);

    foreach(Solid solid; _solids)
        solid.draw();

    foreach(Actor actor; _actors)
        actor.draw();

    foreach(Enemy enemy; _enemies)
        enemy.draw();

    foreach(Projectile projectile; _projectiles)
        projectile.draw();

    /*foreach(Solid solid; _solids)
        solid.drawHitbox();

    foreach(Actor actor; _actors)
        actor.drawHitbox();*/
}

void spawnSolid(Solid solid) {
    _solids.push(solid);
}

void spawnActor(Actor actor) {
    _actors.push(actor);
}

void spawnEnemy(Enemy enemy) {
    _enemies.push(enemy);
}

void spawnProjectile(Projectile projectile) {
    _projectiles.push(projectile);
}

/// Is there any solid there ?
Solid collideAt(Vec2i point, Vec2i halfSize) {
    foreach(Solid solid; _solids) {
        if(solid.collideWith(point, halfSize))
            return solid;
    }
    return null;
}
Player collidePlayerAt(Vec2i point, Vec2i halfSize) {
    if((_player.left < (point.x + halfSize.x)) && (_player.down < (point.y + halfSize.y)) &&
        (_player.right > (point.x - halfSize.x)) && (_player.up > (point.y - halfSize.y)))
      		return _player;
    return null;
}

private bool intersect(Vec2i center, int radius, Vec2i pos, Vec2i halfSize) {
	auto rect = pos - halfSize;
	auto rectSz = halfSize*2;
	auto deltaX = center.x - max(rect.x, min(center.x, rect.x + rectSz.x));
	auto deltaY = center.y - max(rect.y, min(center.y, rect.y + rectSz.y));
	return (deltaX * deltaX + deltaY * deltaY) < (radius * radius);
}

Solid collideAt(Vec2i point, int radius) {
    foreach(Solid solid; _solids) {
        if(intersect(point, radius, solid.position, solid.hitbox))
            return solid;
    }
    return null;
}
Player collidePlayerAt(Vec2i point, int radius) {
    if(intersect(point, radius, _player.position, _player.hitbox))
      	return _player;
    return null;
}

Player getPlayer() {
	return _player;
}