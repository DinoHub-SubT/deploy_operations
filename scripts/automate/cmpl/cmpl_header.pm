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
  @_git
  @_git_status
  @_git_sync
  @_git_add
  @_cloud
  @_cloud_terra
  @_tools
);

# these are exported by default.
our @EXPORT = qw(
  @_subt
  @_git
  @_git_status
  @_git_sync
  @_git_add
  @_cloud
  @_cloud_terra
  @_tools
);

our (
  @_subt,
  @_git,
  @_git_status,
  @_git_sync,
  @_git_add,
  @_cloud,
  @_cloud_terra,
  @_tools
);

# //////////////////////////////////////////////////////////////////////////////
# @brief general arrays for [TAB] autocompletion
# //////////////////////////////////////////////////////////////////////////////
@_subt          = ( "cloud", "deployer", "git", "tools", "ansible", "help" );

@_tools         = ( "ssh.probe" , "teamviewer.probe", "snapshot", "discover");

@_git_status    = ( "basestation", "common", "perception", "simulation", "subt_launch",
                    "ugv", "uav", "help" );

@_git_sync      = ( "deploy", "basestation", "common", "perception", "simulation", "subt_launch",
                    "ugv", "uav", "help" );
@_git_add       = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );

@_cloud         = ( "terraform", "ansible", "help" );
@_cloud_terra   = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" , "destroy",
                    "env", "monitor", "list" );

