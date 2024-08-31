# xbpsman
![image](./xbpsman.gif)
## Purpose

xbpsman is a terminal/cli front-end to xbps to make managing packages easier. It's a menu-driven bash script using gum. I may have pv as an optional dependency in the near future.

Right now, you can update packages, search and add packages, and remove packages with this.

There will be more added to this in the future.

## Dependencies

* gum (can be installed with the installer for xbpsman)
* go (only if you decide to install gum from the go repositories, which tends to be more up to date)
  
## Installation

1. `git clone https://github.com/fearlessgeekmedia/xbpsman.git`
2. `cd xbpsman`
3. `./install`
4. Answer the prompts to install xbpsman, and if needed, gum.
5. Now you can run `xbpsman`

## Changelog

### v.0.18 - 08/30/2024
* Fixed the glitchiness that would happen when searching through packages.

### v.0.17 - 08/23/2024
* Found the color on the menu doesn't change in Cool Retro Term, so I put `=>` in front of what is selected in case your terminal emulator doesn't show the selected item's background color.

### v.0.16 - 08/19/2024
* Fixed a bug where in packages with a period in the name, it didn't get the whole filename.

### v.0.15 - 08/17/2024
* Made visual improvements
* Fixed visual bugs that were happening
* Using tput for a few things.

## To-Do
* Add support for using different flags (such as --force)
* Correct exiting the program so that the terminal characters don't get messed up
* Add ability to add and remove repos
* Add ability to install locally downloaded packages
* Fix some glitches that happen in the terminal when searching through packages
