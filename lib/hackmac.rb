# Hackmac is a set of Ruby tools specifically designed for managing and
# customizing Hackintosh configurations. While primarily intended for users
# with Hackintosh setups, it may also be useful for ordinary Mac users who want
# to leverage its features for monitoring system performance using `gfxmon`.
#
# The library provides core functionality for:
# - EFI partition management
# - GPU performance monitoring
# - USB bootable drive creation
# - System configuration and validation
module Hackmac
end

require 'json'
require 'pathname'
require 'tins/xt'
require 'hackmac/version'
require 'hackmac/plist'
require 'hackmac/disks'
require 'hackmac/ioreg'
require 'hackmac/asset_tools'
require 'hackmac/github_source'
require 'hackmac/url_download'
require 'hackmac/kext'
require 'hackmac/kext_upgrader'
require 'hackmac/oc'
require 'hackmac/oc_upgrader'
require 'hackmac/oc_validator'
require 'hackmac/config'
require 'hackmac/utils'
require 'hackmac/graph'
