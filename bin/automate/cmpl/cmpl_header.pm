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
  @_git_reset
  @_git_clean
  @_git_rm
  @_cloud
  @_cloud_terra
  @_cloud_ani
  @_tools

  chk_flag
  uniq
  remove_trail_dot
  remove_lead_dot
);

# these are exported by default.
our @EXPORT = qw(
  @_subt
  @_git
  @_git_status
  @_git_sync
  @_git_add
  @_git_reset
  @_git_clean
  @_git_rm
  @_cloud
  @_cloud_terra
  @_cloud_ani
  @_tools

  chk_flag
  uniq
  remove_trail_dot
  remove_lead_dot
);

our (
  @_subt,
  @_git,
  @_git_status,
  @_git_sync,
  @_git_add,
  @_git_reset,
  @_git_clean,
  @_git_rm,
  @_cloud,
  @_cloud_terra,
  @_cloud_ani,
  @_tools
);

# //////////////////////////////////////////////////////////////////////////////
# @brief general arrays for [TAB] autocompletion
# //////////////////////////////////////////////////////////////////////////////
@_subt         = ( "cloud", "deployer", "git", "tools", "update", "help" );

@_git          = ( "status", "sync", "add", "clone", "rm", "reset", "clean", "pr", "help" );

@_git_status   = ( "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

@_git_sync     = ( "deploy", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

@_git_add      = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );

@_git_reset    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "ugv.base", "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam",
                      "uav.hardware", "help");

@_git_clean    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

@_git_rm       = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");

@_cloud        = ( "terraform", "ansible", "help" );

@_cloud_terra  = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" , "destroy",
                      "env", "monitor" );

@_cloud_ani    = ( "-az", "-r", "-l", "-b", "-p" );

@_tools        = ( "ssh", "teamviewer", "rdp", "snapshot" );


# //////////////////////////////////////////////////////////////////////////////
# @brief general tools
# //////////////////////////////////////////////////////////////////////////////

# @brief check string equalities
sub chk_flag {
  my ($_flag, $_args) = @_;
  $_args =~ m/$_flag/ ? return 1 : return 0;
}

# @brief filter unique strings from array
# @reference: https://perldoc.perl.org/perlfaq4.html#How-can-I-remove-duplicate-elements-from-a-list-or-array%3f
sub uniq {
  my %seen;
  my @unique = grep { ! $seen{ $_ }++ } @_;
  return @unique
}

sub remove_trail_dot {
  $_[0]=~ s/\.+$//;
}
sub remove_lead_dot {
  $_[0]=~ s/^\.+//;
}
