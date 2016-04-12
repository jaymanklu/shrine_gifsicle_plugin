## Gifsicle Plugin for Shrine

Plugin to wrap [gifsicle](www.lcdf.org/gifsicle/) operations for [shrine file uploader gem](http://shrinerb.com) -

WIP:
- Currently only I have wrapped `resize` from gifsicle as it is the most used for creating different versions with sizes
- Some more loose ends needs to be closed

### How to use

* Place the plugin in `/shrine/plugins/` in you ruby loadpath

And then write an Shrine Uploader and use the plugin

```
class GifUploader < Shrine
  plugin :gifsicle
  ...

  def process(io, context)
    original = io.download

    processed = resize_gif(original, width: 100, height: 100)
  end
end
```

MIT License
