module game.scene.solid;

import std.math;
import std.algorithm: canFind;
import atelier;
import game.scene.world, game.scene.actor;

alias SolidArray = IndexedArray!(Solid, 5000u);

/// An environment collider than interacts with actors.
abstract class Solid {
    private {
        Vec2f _moveRemaining = Vec2f.zero;
        Vec2i _position = Vec2i.zero, _hitbox = Vec2i.zero;
        bool _isCollidable = true;
    }

    @property {
        /// Left (x-axis) bound of the solid's hitbox.
        int left() const { return _position.x - _hitbox.x; }
        /// Right (x-axis) bound of the solid's hitbox.
        int right() const { return _position.x + _hitbox.x; }

        /// Down (y-axis) bound of the solid's hitbox.
        int down() const { return _position.y - _hitbox.y; }
        /// Up (y-axis) bound of the solid's hitbox.
        int up() const { return _position.y + _hitbox.y; }

        /// Integer locked physical position.
        Vec2i position() const { return _position; }
        /// Ditto
        Vec2i position(Vec2i v) { return _position = v; }

        /// Integer locked physical bounds.
        Vec2i hitbox() const { return _hitbox; }
        /// Ditto
        Vec2i hitbox(Vec2i v) { return _hitbox = v; }
    }

    /// 2d-space position.
    Vec2f getPosition2d() const {
        return Vec2f(_position.x, -_position.y);
    }

    /// 2d-space size.
    Vec2f getHitboxSize2d() const {
        return Vec2f(_hitbox.x, _hitbox.y) * 2f;
    }

    /// 2d-space top-left corner.
    Vec2f getHitboxOrigin2d() const {
        return Vec2f(
            _position.x - _hitbox.x,
            -_position.y - _hitbox.y);
    }

    final void moveX(float x) {
        move(x, 0f);
    }

    final void moveY(float y) {
        move(0f, y);
    }

    final void move(float x, float y) {
        _moveRemaining.x += x;
        _moveRemaining.y += y;

        int moveX = cast(int) round(_moveRemaining.x);
        int moveY = cast(int) round(_moveRemaining.y);

        if(moveX || moveY) {
            const Actor[] ridingActors = getAllRidingActors();

            _isCollidable = false;

            if(moveX) {
                _moveRemaining.x -= moveX;
                _position.x += moveX;

                if(moveX > 0) {
                    foreach(Actor actor; getWorldActors()) {
                        if(overlapWith(actor)) {
                            actor.moveX(right - actor.left, &actor.squish);
                        }
                        else if(ridingActors.canFind(actor)) {
                            actor.moveX(moveX, null);
                        }
                    }
                }
                else {
                    foreach(Actor actor; getWorldActors()) {
                        if(overlapWith(actor)) {
                            actor.moveX(left - actor.right, &actor.squish);
                        }
                        else if(ridingActors.canFind(actor)) {
                            actor.moveX(moveX, null);
                        }
                    }
                }
            }
            if(moveY) {
                _moveRemaining.y -= moveY;
                _position.y += moveY;

                if(moveY > 0) {
                    foreach(Actor actor; getWorldActors()) {
                        if(overlapWith(actor)) {
                            actor.moveY(up - actor.down, &actor.squish);
                        }
                        else if(ridingActors.canFind(actor)) {
                            actor.moveY(moveY, null);
                        }
                    }
                }
                else {
                    foreach(Actor actor; getWorldActors()) {
                        if(overlapWith(actor)) {
                            actor.moveY(down - actor.up, &actor.squish);
                        }
                        else if(ridingActors.canFind(actor)) {
                            actor.moveY(moveY, null);
                        }
                    }
                }
            }

            _isCollidable = true;
        }
    }

    final Actor[] getAllRidingActors() {
        Actor[] ridingActors;
        foreach(Actor actor; getWorldActors()) {
            if(actor.isRiding(this))
                ridingActors ~= actor;
        }
        return ridingActors;
    }

    /// Check if a point collides with this solid.
    final bool collideWith(Vec2i point, Vec2i hitbox) {
        if(!_isCollidable)
            return false;
        return
            (left < (point.x + hitbox.x)) && (down < (point.y + hitbox.y)) &&
            (right > (point.x - hitbox.x)) && (up > (point.y - hitbox.y));
    }

    /// Check if an actor is inside this solid.
    final bool overlapWith(Actor actor) {
        return
            (left < actor.right) && (down < actor.up) &&
            (right > actor.left) && (up > actor.down);
    }

    /// Solid logic.
    abstract void update(float deltaTime);
    /// Render the solid.
    abstract void draw();

    /// Display the collider of the solid.
    final void drawHitbox() {
        drawRect(
            getHitboxOrigin2d(),
            getHitboxSize2d(),
            Color.white);
    }
}
