# Godot 2D Platformer Redux


## Description

This project uses one of godot's starter kits, then using heartbeast RPG statemachine logic, and some of my own logic intwined. I plan on making this my own custom template for all to use, inconjuction with my own assets, but for now i will use Itch.io assets until further notice.

## Features

### Player
* Animations/Spritesheets
  * Using AnimtedSprite2D w/ Animation player for multiple spritesheet workflows
  * function callbacks for attack system
* Attack System
  * Ground/Air Attack system (verrry basic for right now)
  * Functions to implement when attack is ended
* State Machine
  * Hardcoded statemachine
  * Using the spritesheet workflow, makes it easier to implement any action
* Movement
  * Coyote timing for jumps
  * wall jumps
  * dash
  * fast fall
 
### Enemy (currently disabled for now)
  * Simple hurtbox
  * simple animations (not same as player - will fix)
  * no movement logic/AI

 ### Levels
  * Using Tilemaps
  * Different tilemap layers
  * death boxes that restart player at spawn point
  * win screen with a button acting as a level finisher

### UI (Basic)
  * Main Menu
  * Options Menu
  * Win Screen

## TODO
- [ ] Upload images for easy viewing
- [ ] Clean up Player script
     - [x] Refactor spaghetti code
     - [x] "globalize" animations for easier use for debugging
     - [ ] expand hurtbox/hitbox
     - [x] health system (Basic system implemented)
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

* Myself (Dax272)

## Version History

* 0.1
    * Initial Release
* 0.2
    * rework of player scripts, now has proper acceleration, coyote jump timing
    * rework animation system so that now animations look cleaner in code
* 0.3
    * rework player with coyote timing, dash proper implementation, etc
    * health component system with enemies and damage calculation based on factors such as armor/defense
* 0.5
    * first full release
    * reworked alot of spaghetti code -> did some recall on personal changes since i found out its easier to do hard code some things

## Acknowledgments

Inspiration, code snippets, etc.
* [Godot Starter Kit](https:TODO)
* [2D Assets](www.Kenney.nl)
