module game.scene.projectile;

import atelier, grimoire;
import game.scene.solid;
import game.scene.actor;
import game.scene.player;
import game.scene.actor : CollisionData;
import game.scene.world;
import game.script.handler;
import game.script.player : grPlayer;
import game.script.projectile : grProjectile;

alias ActionSolid = void delegate(Projectile, CollisionData);
alias ActionActor = void delegate(Projectile, Actor);
alias ActionPlayer = void delegate(Projectile, Player);
alias ProjectileArray = IndexedArray!(Projectile, 5000u);

enum CollisionModel {
	Hitbox,
	Radius
}

/// Basic wall, do nothing.
class Projectile {
    private {
        Vec2f _moveRemaining = Vec2f.zero;
        Vec2i _position = Vec2i.zero, _hitbox = Vec2i.zero;
		ActionSolid onSolid;
		ActionPlayer onPlayer;
		ActionActor onActor;
		CollisionModel collisionMode;
    }

	bool setForDeletion = false;
	bool collidedThisFrame = false;

    this(Vec2i position_, Vec2i hitbox_, CollisionModel mode = CollisionModel.Hitbox, dstring eventSolid = "", dstring eventPlayer = "", dstring eventActor = "") {
		GrType[] arr;
        position = position_;
        hitbox = hitbox_;
		collisionMode = mode;
		if(eventSolid != "") {
			auto name = grMangleNamedFunction(eventSolid, arr);
			assert(testEvent(name));
			onSolid = delegate (Projectile proj, CollisionData data) {
				auto ev = spawnEvent(name);
				ev.setUserData!Projectile(proj);
				ev.setUserData!Solid(data.solid);	
			};
		} else {
			onSolid = delegate (Projectile, CollisionData) {};
		}
		if(eventPlayer != "") {
			auto name = grMangleNamedFunction(eventPlayer, [grProjectile, grPlayer]);
			assert(testEvent(name));
			onPlayer = delegate (Projectile proj, Player data) {
				auto ev = spawnEvent(name);
				ev.setUserData!Projectile(proj);
				ev.setUserData!Player(data);	
			};
		} else {
			onSolid = delegate (Projectile, Player) {};
		}
		if(eventActor != "") {
			auto name = grMangleNamedFunction(eventActor, arr);
			assert(testEvent(name));
			/*onPlayer = delegate (Projectile proj, Player data) {
				auto ev = spawnEvent(name);
				ev.setUserData!Projectile(proj);
				ev.setUserData!Player(data);	
			};
		} else {
			*/
			
		}
		onActor = delegate (Projectile, Actor) {};
    }

    @property {
        /// Left (x-axis) bound of the actor's hitbox.
        int left() const { return _position.x - _hitbox.x; }
        /// Right (x-axis) bound of the actor's hitbox.
        int right() const { return _position.x + _hitbox.x; }

        /// Down (y-axis) bound of the actor's hitbox.
        int down() const { return _position.y - _hitbox.y; }
        /// Up (y-axis) bound of the actor's hitbox.
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

    /// Move on the horizontal axis.
    final void move(Vec2f direction) {
		ActionSolid onCollideSolid = onSolid;
		ActionPlayer onCollidePlayer = onPlayer;
		ActionActor onCollideAction = onActor;

		const auto len = direction.length;
		const auto scale = _hitbox.length;

		if(len<scale)
		{
			moveX(direction.x,  onCollideSolid,  onCollidePlayer,  onCollideAction);
			moveY(direction.y,  onCollideSolid,  onCollidePlayer,  onCollideAction);
		}
		else
		{
			auto rescale = direction/scale;
			auto steps = len/scale - 1;
			moveX(rescale.x/2, onCollideSolid,  onCollidePlayer,  onCollideAction);
			moveY(rescale.y/2, onCollideSolid,  onCollidePlayer,  onCollideAction);
			direction -= rescale/2;
			while(steps > 0)
			{
				moveX(rescale.x,onCollideSolid,  onCollidePlayer,  onCollideAction);
				moveY(rescale.y,onCollideSolid,  onCollidePlayer,  onCollideAction);
				direction -= rescale;
				steps--;
			}
			moveX(direction.x, onCollideSolid,  onCollidePlayer,  onCollideAction);
			moveY(direction.y, onCollideSolid,  onCollidePlayer,  onCollideAction);
		}
    }

    /// Move on the horizontal axis.
    final void moveX(float x, ActionSolid onCollideSolid, ActionPlayer onCollidePlayer, ActionActor onCollideAction) {
        _moveRemaining.x += x;
        int move = cast(int) round(_moveRemaining.x);

        if(move != 0 && !setForDeletion) {
            _moveRemaining.x -= x;
            int dir = move > 0 ? 1 : -1;

            while(move && !setForDeletion) {
                if(onPlayer && !collidedThisFrame) {
					Player player = 
						collisionMode == CollisionModel.Hitbox ? collidePlayerAt(_position + Vec2i(dir, 0), _hitbox) :
						collisionMode == CollisionModel.Radius ? collidePlayerAt(_position + Vec2i(dir, 0), _hitbox.x) :
						null
					;
					if(player) {
						onPlayer(this, player);
						collidedThisFrame = true;
					}
				}
                if(onActor && !collidedThisFrame) {
				}
                if(onSolid && !collidedThisFrame) {
					Solid solid = 
						collisionMode == CollisionModel.Hitbox ? collideAt(_position + Vec2i(dir, 0), _hitbox) :
						collisionMode == CollisionModel.Radius ? collideAt(_position + Vec2i(dir, 0), _hitbox.x) :
						null
					;
					if(solid) {
						CollisionData data;
						data.solid = solid;
						data.direction = Vec2i(dir, 0);
						onSolid(this, data);
						collidedThisFrame = true;
					}
                }
                _position.x += dir;
                move -= dir;
            }
        }
    }

    /// Move on the vertical axis.
    final void moveY(float y, ActionSolid onCollideSolid, ActionPlayer onCollidePlayer, ActionActor onCollideAction) {
        _moveRemaining.y += y;
        int move = cast(int) round(_moveRemaining.y);

        if(move != 0  && !setForDeletion) {
            _moveRemaining.y -= y;
            int dir = move > 0 ? 1 : -1;

            while(move && !setForDeletion) {
                if(onPlayer && !collidedThisFrame) {
					Player player = 
						collisionMode == CollisionModel.Hitbox ? collidePlayerAt(_position + Vec2i(0, dir), _hitbox) :
						collisionMode == CollisionModel.Radius ? collidePlayerAt(_position + Vec2i(0, dir), _hitbox.x) :
						null
					;
					if(player) {
						onPlayer(this, player);
						collidedThisFrame = true;
					}
				}
                if(onActor && !collidedThisFrame) {
				}
                if(onSolid && !collidedThisFrame) {
					Solid solid = 
						collisionMode == CollisionModel.Hitbox ? collideAt(_position + Vec2i(0, dir), _hitbox) :
						collisionMode == CollisionModel.Radius ? collideAt(_position + Vec2i(0, dir), _hitbox.x) :
						null
					;
					if(solid) {
						CollisionData data;
						data.solid = solid;
						data.direction = Vec2i(0, dir);
						onSolid(this, data);
						collidedThisFrame = true;
					}
                }
                _position.y += dir;
                move -= dir;
            }
        }
    }

    void update(float deltaTime) {

    }

    void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.magenta);
    }
}