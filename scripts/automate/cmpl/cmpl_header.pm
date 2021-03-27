#!/usr/local/bin/perl

package cmpl_header;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_subt
  @_git_status
  @_git_sync
  @_git_add
  @_cloud
  @_tools
);

# these are exported by default.
our @EXPORT = qw(
  @_subt
  @_git_status
  @_git_sync
  @_git_add
  @_cloud
  @_tools
);

our (
  @_subt,
  @_git_status,
  @_git_sync,
  @_git_add,
  @_cloud,
  @_tools
);

# //////////////////////////////////////////////////////////////////////////////
# @brief general arrays for [TAB] autocompletion
# //////////////////////////////////////////////////////////////////////////////
@_subt          = ( "cloud", "deployer", "git", "tools", "tutorial" );

@_tools         = ( "ssh.probe" , "teamviewer.probe", "snapshot", "rdp");

@_cloud         = ( "terraform", "ansible" );

@_git_status    = ( "basestation", "common", "perception", "simulation", "subt_launch",
                    "ugv", "uav", "help" );

@_git_sync      = ( "deploy", "basestation", "common", "perception", "simulation", "subt_launch",
                    "ugv", "uav", "help" );
@_git_add       = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );

