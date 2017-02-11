class Utilities
  class << self

    def escape_chars(string)
      string.tr('(', '-').tr(')', '-').tr(' ', '_').tr("\\", "-").tr("/", "-").tr(":", "-").tr("*", "-").tr("?", "-").tr("<", "-").tr(">", "-").tr("|", "-").tr("\"", "-").tr("&", "and")
    end

    def mkchdir(dir)
      system 'mkdir', '-p', dir
      Dir.chdir(dir) do
        yield
      end
    end

  end
end