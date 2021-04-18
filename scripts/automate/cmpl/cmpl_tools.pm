#!/usr/local/bin/perl

package cmpl_tools;
use Exporter;
use FindBin;
use cmpl_utils;
use cmpl_help;
use Env;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_tools
  @_tools_help
);

# these are exported by default.
our @EXPORT = qw(
  @_tools
  @_tools_help
);

our (
  @_tools,
  @_tools_help
);

# read the tools's cli cmpl matches
@_tools  = ( "probe.ssh", "probe.teamviewer", "rdp", "snapshot", "verify.ops");

# //////////////////////////////////////////////////////////////////////////////
# @brief various help messages
# //////////////////////////////////////////////////////////////////////////////

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
# - TODO: update this matcher, to use better regex patterns...
@_tools_help = ({
  id      => "tools",
  help    => create_help(get_help(qw(probe_ssh probe_teamviewer rdp snapshot verify_ops))),
});

