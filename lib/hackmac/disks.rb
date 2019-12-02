require 'hackmac/plist'

module Hackmac
  class DiskInfo
    include Hackmac::Plist

    def initialize(disk:)
      @disk = disk
      plist *(%w[ diskutil info -plist ] << disk)
    end

    attr_reader :disk
  end

  class Disks
    include Hackmac::Plist

    def initialize(limiter: nil, device: nil)
      plist *(%w[ diskutil list -plist ] + [ limiter, device ].compact)
    end
  end

  class ContainerDisk < Disks
    def initialize(disk:, limiter: nil)
      @disk = disk
      device = `#{Shellwords.join(%w[ diskutil list ] << disk)}`.
        lines.grep(/Apple_APFS/).first&.split(/\s+/)&.[](4)

      super device: device, limiter: limiter
    end
  end
end
