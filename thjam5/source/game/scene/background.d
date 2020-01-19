
module game.scene.background;

import atelier;

class Background {
    Sprite _background;
    Sprite _boss1;
    Sprite _boss2;

    this() {}

    void load(string backgroundName, string boss1Name, string boss2Name) {
        _background = fetch!Sprite(backgroundName);
        _boss1      = fetch!Sprite(boss1Name);
        _boss2      = fetch!Sprite(boss2Name);

        _background.size *= 1.75f;
    }

    void draw() {
        if(_background !is null) {
            _background.draw(Vec2f.zero);
            _boss1.draw(Vec2f(0f, 250f));
            _boss2.draw(Vec2f(400f, 400f));
        }
    }
}