## Crushberry Smoothie Plugin
## RPG Maker VX Ace Plugin (Script) for Crushberry Spectrumdon game.

# Customizable file name suffix to disable looping for animated files (ex: image.noloop.gif).
$NO_LOOP_FILE_SUFFIX = ".noloop"

class Bitmap
  alias old_initialize initialize

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
      self.bitmap = nil
    else
      new_bitmap = Cache.picture(@picture.name)
      
      # Check if the bitmap is changed.
      just_shown = self.bitmap != new_bitmap
      
      self.bitmap = new_bitmap
      
      print("yes") if just_shown
      # Restart animated bitmap from first frame if just shown.
      self.bitmap.replay() if just_shown
    end
  end
end