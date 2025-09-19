require 'hackmac/plist'

module Hackmac
  # A class that provides detailed information about a specific disk by
  # querying the system's disk utility.
  #
  # The DiskInfo class interfaces with macOS's diskutil command to retrieve
  # comprehensive details about a specified disk.
  #
  # @example
  #   disk_info = Hackmac::DiskInfo.new(disk: '/dev/disk0')
  #   # Provides access to disk information through method calls
  class DiskInfo
    include Hackmac::Plist
    # The initialize method sets up a DiskInfo instance by retrieving detailed
    # information about a specific disk.
    #
    # This method constructs and executes a system command to fetch
    # comprehensive details about the specified disk using diskutil's info
    # functionality with plist output format. The resulting plist data is
    # parsed and made available for querying through dynamic method calls.
    #
    # @param disk [ String ] the disk identifier to retrieve information for
    def initialize(disk:)
      @disk = disk
      plist(**(%w[ diskutil info -plist ] << disk))
    end

    # The disk reader method provides access to the disk identifier that was
    # used when initializing the DiskInfo instance.
    #
    # @return [ String ] the disk identifier associated with this instance
    attr_reader :disk
  end

  # A class that provides access to comprehensive disk information by querying
  # macOS's diskutil command
  #
  # The Disks class interfaces with the diskutil utility to retrieve detailed
  # information about all disks in the system. It executes system commands to
  # gather plist-formatted data about disk configurations and makes this
  # information available through dynamic method calls for easy access and
  # manipulation.
  #
  # @example
  #   disks = Hackmac::Disks.new
  #   # Provides access to disk information through method calls
  class Disks
    include Hackmac::Plist

    # The initialize method sets up a Disks instance by executing a system
    # command to retrieve comprehensive disk information.
    #
    # This method constructs and runs a shell command using the diskutil
    # utility to fetch detailed information about all disks in the system. It
    # processes the XML output, extends the resulting hash with deep find
    # capabilities, and stores the largest matching result set in the instance
    # variable.
    #
    # @param limiter [ String ] optional parameter to limit the output of diskutil list
    # @param device [ String ] optional parameter to specify a particular device to query
    def initialize(limiter: nil, device: nil)
      plist(*(%w[ diskutil list -plist ] + [ limiter, device ].compact))
    end
  end

  # A class that provides access to APFS container disk information by querying
  # macOS's diskutil command
  #
  # The ContainerDisk class extends the Disks class to specifically retrieve
  # and process information about Apple File System (APFS) containers
  #
  # This class initializes by taking a disk identifier and searching for the
  # corresponding Apple_APFS device within the diskutil list output
  #
  # It then uses the APFS device path to construct a Disks instance, allowing
  # access to detailed APFS container information through dynamic method calls
  #
  # @example
  #   container_disk = Hackmac::ContainerDisk.new(disk: '/dev/disk0')
  #   # Provides access to APFS container information through method calls
  class ContainerDisk < Disks
    # The initialize method sets up a ContainerDisk instance by identifying and
    # initializing with the APFS device associated with a given disk.
    #
    # This method takes a disk identifier and searches for the corresponding
    # Apple_APFS device within the diskutil list output. It extracts the device
    # path and passes it along to the parent Disks class constructor, allowing
    # for further processing of APFS container information.
    #
    # @param disk [ String ] the disk identifier to search for APFS container device
    # @param limiter [ String ] optional parameter to limit the output of diskutil list
    def initialize(disk:, limiter: nil)
      @disk = disk
      device = `#{Shellwords.join(%w[ diskutil list ] << disk)}`.
        lines.grep(/Apple_APFS/).first&.split(/\s+/)&.[](4)

      super device: device, limiter: limiter
    end
  end
end
