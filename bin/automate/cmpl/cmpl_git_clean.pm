#!/usr/local/bin/perl

package cmpl_git_clean;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_git_clean
  $_deployer_local_help
  @_git_clean_help
);

# these are exported by default.
our @EXPORT = qw(
  @_git_clean
  $_deployer_local_help
  @_git_clean_help
);

our (
  @_git_clean,
  $_deployer_local_help,
  @_git_clean_help
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (git clean) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////
@_git_clean     = (
  "localhost.basestation",
  "localhost.common",
  "localhost.perception",
  "localhost.subt_launch",
  "localhost.simulation",
  "localhost.ugv",
  "localhost.uav",

  "basestation.system76.basestation",
  "basestation.system76.common",
  "basestation.system76.perception",
  "basestation.system76.subt_launch",
  "basestation.system76.simulation",
  "basestation.system76.ugv",
  "basestation.system76.uav",

  "basestation.laptop.basestation",
  "basestation.laptop.common",
  "basestation.laptop.perception",
  "basestation.laptop.simulation",
  "basestation.laptop.subt_launch",
  "basestation.laptop.uav",
);

$_deployer_system_help = ("
About: 1... cleans submodules to one of the sysmtes.
About: 2... == Your Options Are ==
localhost     : cleans the submodules for developing on a localhost.
basestation   : cleans the submodules for developing on one of the basestation laptops.
slam          : cleans the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 1... cleans the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
uav                : ~/deploy_ws/src/uav
");

$_deployer_basestation_help = ("
About: 1... cleans the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
system76        : system76-pc laptop, for running both ugv & uav robots
laptop          : the uav specific drone laptop
");

$_deployer_system76_help = ("
About: 1... cleans the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
uav                : ~/deploy_ws/src/uav
");

$_deployer_laptop_uav_help = ("
About: 1... cleans the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
uav                : ~/deploy_ws/src/uav
");


# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_git_clean_help = ({
  id      => "clean",
  help    => $_deployer_system_help,
},{
  id      => "localhost",
  help    => $_deployer_localhost_help,
},{
  id      => "slam.uav",
  help    => $_deployer_slam_uav_help,
},{
  id      => "basestation",
  help    => $_deployer_basestation_help,
},{
  id      => "basestation.system76",
  help    => $_deployer_system76_help,
},{
  id      => "basestation.laptop",
  help    => $_deployer_laptop_uav_help,
});
