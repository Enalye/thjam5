module game.scene.haniwa;

import atelier;
import std.stdio;
import game.scene.actor, game.scene.solid, game.scene.world;

alias HaniwaArray = IndexedArray!(Haniwa, 500u);

class Haniwa: Solid {
    private {
        int   _facing;
        float _speed = 1f;

        enum acceleration = 0.2f;
        enum maxSpeed     = 5f;
        Animation animation;
    }

    bool toDelete = false;

    this(Vec2i position_, Vec2i hitbox_, int facing) {
        position = position_;
        hitbox   = hitbox_;  
        _facing  = facing;

        animation = fetch!Animation("haniwa");
        if(_facing == -1) {
            animation.flip = Flip.horizontal;
        }

        animation.start();
    }

    override void update(float deltaTime) {
        _speed = approach(_speed, maxSpeed * _facing, acceleration);
        handleMovement(_speed, &onHitWall);
        animation.update(deltaTime);
    }

    final void handleMovement(float x, Action onCollide) {
        moveX(x);

        Solid solid = collideAt(position + Vec2i(_facing, 0), hitbox);
        if(solid && onCollide) {
            CollisionData data;
            data.solid     = solid;
            data.direction = Vec2i(_facing, 0);
            onCollide(data);
        }

        if(isOutsideScreen(position)) {
            toDelete = true;
        }
    }

    /// Render the actor.
    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.black);
        animation.draw(getHitboxOrigin2d());                   
    }

    /// We touch a wall left or right.
    void onHitWall(CollisionData data) {
        _speed = 0f;
    }
}