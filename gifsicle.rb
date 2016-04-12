require "tempfile"

class Shrine
  module Plugins
    # The gifsicle plugin provides wrapper instance methods for Shrine to work with
    # gifsicle command line package
    #
    #     plugin :gifsicle
    #
    # Instance method `resize_gif` gives resizing gif functionality using gifsicle
    module Gifsicle
      module InstanceMethods
        def resize_gif(image, args = {})
          width  = args[:width] || '_'
          height = args[:height] || '_'

          original_file = _copy_to_tempfile(image)

          processed_file = Tempfile.new(['', '.gif'])

          command = "gifsicle -i --unoptimize -O3 --resize #{width}x#{height} #{original_file.path} > #{processed_file.path}"
          _run_command command
          processed_file
        end

        # this method is lifted from image_processing gem
        # copies the original image to a tempfile because we don't want to mess with the original
        def _copy_to_tempfile(file)
          args = [File.basename(file.path, ".*"), File.extname(file.path)] if file.respond_to?(:path)
          tempfile = Tempfile.new(args || "image", binmode: true)
          IO.copy_stream(file, tempfile.path)
          file.rewind
          tempfile
        end

        # this method is from mini_magick using posix_spawn
        def _run_command(command)
          require "posix-spawn"

          pid, stdin, stdout, stderr = POSIX::Spawn.popen4(command)
          Process.waitpid(pid)

          # $?.exitstatus contains exit status do something with it if non zero raise error maybe
        end
      end
    end

    register_plugin(:gifsicle, Gifsicle)
  end
end
