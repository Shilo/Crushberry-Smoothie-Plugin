## Crushberry Smoothie Plugin
## RPG Maker VX Ace Plugin (Script) for Crushberry Spectrumdon game.
## Copyright (C) 2024 Crushberry Spectrumdon & Shilo.

# Customizable file name suffix to disable looping for animated files (ex: image.noloop.gif).
$NO_LOOP_FILE_SUFFIX = ".noloop"

## Don't edit below this line unless you know what you are doing.

$sprite_pictures_play_state = {}

# Helper methods to call from Event scripts.
class CrushberrySmoothie
  # Wait for frames.
  def self.wait(frames)
    frames.times { Fiber.yield }
  end

  # Wait for animated looping picture to finish playing.
  def self.wait_for_picture(picture_id)
    Fiber.yield while $sprite_pictures_play_state[picture_id] == true
  end
end


class Bitmap
  alias old_initialize initialize

  # Overwrite initialize to disable looping for animated files that end with suffix $NO_LOOP_FILE_SUFFIX.
  def initialize(*args)
    old_initialize(*args)

    # Disable looping for animated files that end with suffix $NO_LOOP_FILE_SUFFIX.
    animated_file_name = self.animated? && args[0].is_a?(String) ? args[0] : ""
    self.looping = false if animated_file_name != "" && animated_file_name.end_with?($NO_LOOP_FILE_SUFFIX)

    # Start playing animated bitmap from first frame.
    self.replay()
  end

  # Restart animated bitmap from first frame if just shown.
  # This is called on initialize() and Sprite_Picture.update_bitmap().
  def replay()
    self.goto_and_play(0) if self.animated?
  end
end

class Sprite_Picture < Sprite
  # Overwrite update transfer origin bitmap to restart animated bitmap from first frame.
  def update_bitmap
    if @picture.name.empty?
      # Set play state to nil when picture is empty.
      $sprite_pictures_play_state[@picture.number] = nil

      self.bitmap = nil
    else
      new_bitmap = Cache.picture(@picture.name)
      
      # Check if the bitmap is changed.
      just_shown = self.bitmap != new_bitmap
      
      self.bitmap = new_bitmap
      
      # Restart animated bitmap from first frame if just shown.
      self.bitmap.replay() if just_shown

      # Set play state to true if animated bitmap is playing/loading and not looping.
      # Play state is always false if bitmap is non-animated or animation is looping.
      $sprite_pictures_play_state[@picture.number] = self.bitmap.animated? && !self.bitmap.looping && (self.bitmap.playing || self.bitmap.current_frame == 0)
    end
  end
end

class Game_Interpreter
  alias old_command_231 command_231

  # Overwrite "Show Picture" command to set play state for animated pictures.
  def command_231
    old_command_231()
    
    # Set play state to true to allow Sprite_Picture.update_bitmap() to update state. 
    $sprite_pictures_play_state[@params[0]] = true
  end
end