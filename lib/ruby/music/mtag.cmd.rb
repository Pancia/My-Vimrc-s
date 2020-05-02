require 'music/music_db.rb'

module MusicCMD

  def mtag(opts)
    opts.banner = "Usage: mtag [OPTS] ITEM"
    opts.info = "Tag the file with metadata (uses ffmpeg)"
    opts.separator "    ITEM: String, will be compared in `jq` to FILTER"
    opts.separator ""
    opts.on("-n", "--dry-run", "Do not tag, just print") {
      $options[:dry_run] = true
    }
    $options[:filter] = ".id"
    opts.on("-f", "--filter FILTER", "Any string that `jq` will accept") { |jqf|
      $options[:filter] = jqf
    }
    lambda { |item|
      MusicDB.tag MusicDB.select(item.gsub(/\..*$/, ""), $options[:filter])
    }
  end

end
