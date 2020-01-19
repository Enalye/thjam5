module game.gui.main;

import std.datetime.stopwatch: StopWatch, AutoStart;
import std.conv: to;
import atelier;
import game.scene;
import game.menu;


private GameInterface _gameInterface;
/// Global interface that displays informations and render the world.
final class GameInterface: GuiElement {
    private {
        World _world;
        Label _timerLabel;
        StopWatch _clock;
    }

    /// Ctor
    this() {
        _gameInterface = this;
        size(screenSize);

        _world = new World;

        _timerLabel = new Label("Time: 0");
        setUi();

        _clock = StopWatch(AutoStart.yes);
    }

    override void update(float deltaTime) {
        _timerLabel.text = "Time: " ~ to!string(_clock.peek.total!"seconds");
    }

    private int _life = 5;
    void setLife(int life) {
        _life = life;
        setUi();
    }

    private int _bombs = 3;
    void setBombs(int bombs) {
        _bombs = bombs;
        setUi();
    }

    void setUi() {
        removeChildrenGuis();
        addChildGui(_world);

        _timerLabel.position(Vec2f(10f, 100f));
        addChildGui(_timerLabel);

        {
            auto sp = fetch!Sprite("vie");
            auto b = new HContainer;
            b.position = Vec2f(10f, 10f);
            b.spacing = Vec2f(20f, 0f);
            addChildGui(b);
            for(int i = 0; i < _life; ++ i) {
                b.addChildGui(new IconSprite(sp));
            }
        }

        {
            auto sp = fetch!Sprite("bombes");
            auto b = new HContainer;
            b.position = Vec2f(10f, 50f);
            b.spacing = Vec2f(20f, 0f);
            addChildGui(b);
            for(int i = 0; i < _bombs; ++ i) {
                b.addChildGui(new IconSprite(sp));
            }
        }
    }
}

final class IconSprite: GuiElement {
    private Sprite _sp;
    this(Sprite sp) {
        _sp = sp;
        size(_sp.size);
    }

    override void draw() {
        _sp.draw(center);
    }
}

void setLifeGui(int life) {
    _gameInterface.setLife(life);
}

void setBombsGui(int bombs) {
    _gameInterface.setBombs(bombs);
}

final class IntroGui1: GuiElement {
    private {
        Sprite _bgSprite, _introSprite;
        Music _music;
    }

    this() {
        _bgSprite = fetch!Sprite("ui.bg");
        _introSprite = fetch!Sprite("ui.intro1");
        size(screenSize);

        _music = fetch!Music("the_idolmaster");
        _music.volume = 0.2f;
        _music.isLooped = true;
        _music.play();

        {
            auto b = new HContainer;
            b.position = Vec2f(20f, 10f);
            b.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.space"));
            b.addChildGui(new Label(" to continue (1/3)."));
        }
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            removeRootGuis();
            addRootGui(new IntroGui2);
        }
    }

    override void draw() {
        _bgSprite.draw(center);
        _introSprite.draw(center);
    }
}

final class IntroGui2: GuiElement {
    private {
        Sprite _bgSprite, _introSprite;
    }

    this() {
        _bgSprite = fetch!Sprite("ui.bg");
        _introSprite = fetch!Sprite("ui.intro2");
        size(screenSize);

        {
            auto b = new HContainer;
            b.position = Vec2f(20f, 10f);
            b.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.space"));
            b.addChildGui(new Label(" to continue (2/3)."));
        }
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            removeRootGuis();
            addRootGui(new IntroGui3);
        }
    }

    override void draw() {
        _bgSprite.draw(center);
        _introSprite.draw(center);
    }
}

final class IntroGui3: GuiElement {
    private {
        Sprite _bgSprite, _introSprite;
    }

    this() {
        _bgSprite = fetch!Sprite("ui.bg");
        _introSprite = fetch!Sprite("ui.intro3");
        size(screenSize);

        {
            auto b = new HContainer;
            b.position = Vec2f(20f, 10f);
            b.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.space"));
            b.addChildGui(new Label(" to continue (3/3)."));
        }
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            removeRootGuis();
            addRootGui(new IntroGui4);
        }
    }

    override void draw() {
        _bgSprite.draw(center);
        _introSprite.draw(center);
    }
}

final class IconAnim: GuiElement {
    private {
        Animation _anim;
    }

    this(string name) {
        _anim = fetch!Animation(name);
        _anim.size /= 2f;
        size(_anim.size);
    }

    override void update(float deltaTime) {
        _anim.update(deltaTime);
    }

    override void draw() {
        _anim.draw(center);
    }
}

final class IntroGui4: GuiElement {
    private {
        Sprite _bgSprite;
    }

    this() {
        _bgSprite = fetch!Sprite("ui.bg");
        size(screenSize);

        {
            auto b = new HContainer;
            b.position = Vec2f(20f, 10f);
            b.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.space"));
            b.addChildGui(new Label(" to start."));
        }

        auto box = new VContainer;
        box.position = Vec2f(100f, 50f);
        box.setChildAlign(GuiAlignX.left);
        addChildGui(box);
        {
            auto b = new HContainer;
            box.addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.left"));
            b.addChildGui(new Label(" and "));
            b.addChildGui(new IconAnim("ui.right"));
            b.addChildGui(new Label(" to move."));
        }
        {
            auto b = new HContainer;
            box.addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.w"));
            b.addChildGui(new Label(" to grab platforms."));
        }
        {
            auto b = new HContainer;
            box.addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.x"));
            b.addChildGui(new Label(" to shoot an haniwa (up to 3)."));
        }
        {
            auto b = new HContainer;
            box.addChildGui(b);

            b.addChildGui(new Label("Press "));
            b.addChildGui(new IconAnim("ui.c"));
            b.addChildGui(new Label(" to jump/double jump/wall jump."));
        }
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            removeRootGuis();
            fetch!Music("the_idolmaster").stop();
            onStartGame();
        }
    }

    override void draw() {
        _bgSprite.draw(center);
    }
}
/*
final class SelectionScreen: GuiElement {
    private {
        Sprite _bgSprite;
        Animation _spaceAnim;
    }

    this() {
        _bgSprite = fetch!Sprite("ui.bg");
        _spaceAnim = fetch!Animation("ui.space");
        size(screenSize);
    }

    override void update(float deltaTime) {
        _spaceAnim.update(deltaTime);
        if(getButtonDown(KeyButton.space)) {
            fetch!Music("the_idolmaster").stop();
            onStartGame();
        }
    }

    override void draw() {
        _bgSprite.draw(center);
        _spaceAnim.draw(Vec2f(center.x, origin.y + size.y - 100f));
    }
}*/