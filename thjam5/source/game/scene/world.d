module game.scene.world;

import atelier;
import game.scene.actor, game.scene.solid, game.scene.player, game.scene.wall;

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
    ActorArray _actors;
    SolidArray _solids;
    Player _player;
}

ActorArray getWorldActors() {
    return _actors;
}

SolidArray getWorldSolids() {
    return _solids;
}

private void initWorld() {
    _actors = new ActorArray;
    _solids = new SolidArray;

    _actors.push(_player = new Player);
    _solids.push(new Wall);
}

private void updateWorld(Canvas canvas, float deltaTime) {
    foreach(Solid solid; _solids)
        solid.update(deltaTime);

    foreach(Actor actor; _actors)
        actor.update(deltaTime);

    canvas.size = screenSize / 2f;
    canvas.position = _player.getPosition2d();
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

    foreach(Solid solid; _solids)
        solid.drawHitbox();

    foreach(Actor actor; _actors)
        actor.drawHitbox();
}

bool collideAt(Vec2i point, Vec2i halfSize) {
    foreach(Solid solid; _solids) {
        if(solid.collideWith(point, halfSize))
            return true;
    }
    return false;
}