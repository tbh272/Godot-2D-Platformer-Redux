# Godot 2D Platformer Redux


## Description

This project uses one of godot's starter kits, then using heartbeast RPG statemachine logic, and some of my own logic intwined. I plan on making this my own custom template for all to use, inconjuction with my own assets, but for now i will use Itch.io assets until further notice.

## Features

* Player
  * Hardcoded statemachine
  * Using animated Sprite with Animation player (easy for multiple sprite sheets while yet wanting a state machine)
  * Simple Attack logic with hitbox (soon a hurtbox will be made)
 
* Enemy
  * Simple hurtbox
  * simple animations (not same as player - will fix)
  * no movement logic/AI

* Levels
  * Using Tilemaps
  * Different Layers
  * not much else to say for this lol 

## TODO
- [ ] Upload images for easy viewing
- [ ] Clean up Player script
     - [x] Refactor spaghetti code
     - [x] "globalize" animations for easier use for debugging
     - [ ] expand hurtbox/hitbox
     - [ ] health system (work in progress)
- [ ] Make/use custom assets
     - [ ] player sprites
     - [ ] enemy sprites
     - [ ] world assets
 
## Getting Started

### Dependencies

* A computer able to run Godot 4

### Installing

* Download as ZIP
* Unzip to project list folder (where you store your projects ex. for using mac usually in documents folder)

## Authors

* Myself (Tyler - Dax272)

## Version History

* 0.1
    * Initial Release
* 0.3
    * rework of player scripts, now has proper acceleration, coyote jump timing
    * rework animation system so that now animations look cleaner in code

## Acknowledgments

Inspiration, code snippets, etc.
* [Heartbeast](https://www.youtube.com/@uheartbeast)
* [Godot Starter Kit](https:TODO)
* 2D Assets www.Kenney.nl
* Sound Fx Gdfxr (Sfxr plugin for godot)
