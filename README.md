# Crushberry-Smoothie-Plugin

RPG Maker VX Ace Plugin (Script) for Crushberry Spectrumdon game.

## Dependencies

[mkxp-z](https://github.com/mkxp-z/mkxp-z) - Open-source cross-platform player

## Installation

Add the contents of [CrushberrySmoothie.rb](CrushberrySmoothie.rb) as a new script named "CrushberrySmoothie" at the bottom of `Tools > Script Editor (F11) > Materials`.

## Features

-   Fixes:
    -   Animated pictures (GIFs) can be non-loopable with filename suffix: `.noloop.gif`
    -   Animated pictures will restart to first frame when picture is changed.
-   Event script helpers:
    -   `CrushberrySmoothie.wait(frame: integer)` - Wait in frames.
    -   `CrushberrySmoothie.wait_seconds(seconds: float)` - Wait for time in seconds.
    -   `CrushberrySmoothie.wait_milliseconds(milliseconds: integer)` - Wait for time in milliseconds.
    -   `CrushberrySmoothie.wait_picture(picture_id: integer)` - Wait for animated non-looping picture to finish.
