# Herbi - On the loose

A retro platformer in which you have to collect all diamonds presented in levels

![](https://github.com/KOBUGE-Games/Herbi/blob/master/splash.png)

## Credits

Game made by @KOBUGE-Games with [Godot Engine](https://godotengine.org/)
Sprites from [SpriteLib](http://www.widgetworx.com/projects/sl.html)


### How to create levels

1. Install Tiled www.mapeditor.org _(In linux it is called "tiled")_
2. Install www.python.org 2.7 _(Already installed by most linux distros)_
3. Copy `level/blank_level.tmx` as `level_0.tmx`
4. Open level_0.tmx with Tiled
5. Save it
6. Run convert_all.py _(Edit line 15 to point it to your tiled executable/binary)_
7. Enable debug mode in global.gd
8. Press T to open Level 0

Once it's set up, making levels will become easier than ever.
