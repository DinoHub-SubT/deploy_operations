#!/usr/local/bin/perl

package cmpl_git_clone;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_git_clone
  $_deployer_local_help
  @_git_clone_help
);

# these are exported by default.
our @EXPORT = qw(
  @_git_clone
  $_deployer_local_help
  @_git_clone_help
);

our (
  @_git_clone,
  $_deployer_local_help,
  @_git_clone_help
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (git clone) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////
@_git_clone     = (
  "localhost.basestation",
  "localhost.common",
  "localhost.perception",
  "localhost.subt_launch",
  "localhost.simulation",
  "localhost.ugv.ppc",
  "localhost.ugv.nuc",
  "localhost.uav.core",
  "localhost.uav.hardware",
  "basestation.system76.basestation",
  "basestation.system76.common",
  "basestation.system76.perception",
  "basestation.system76.subt_launch",
  "basestation.system76.ugv.ppc",
  "basestation.system76.ugv.nuc",
  "basestation.system76.hardware",
  "basestation.system76.uav.core",
  "basestation.system76.uav.hardware",
  "basestation.system76.simulation",
  "basestation.laptop.basestation",
  "basestation.laptop.common",
  "basestation.laptop.perception",
  "basestation.laptop.subt_launch",
  "basestation.laptop.uav.core",
  "basestation.laptop.uav.hardware",
  "basestation.laptop.simulation",
  "slam.ugv.devel",
  "slam.ugv.robot",
  "slam.uav"
);

$_deployer_system_help = ("
About: 1... clones submodules to one of the sysmtes.
About: 2... == Your Options Are ==
localhost     : clones the submodules for developing on a localhost.
basestation   : clones the submodules for developing on one of the basestation laptops.
slam          : clones the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 1... clones the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
ugv.ppc                 : ~/deploy_ws/src/ugv/ppc
ugv.nuc                 : ~/deploy_ws/src/ugv/nuc
uav                : ~/deploy_ws/src/uav
uav.core                : ~/deploy_ws/src/uav/core
uav.hardware            : ~/deploy_ws/src/uav/hardware
");

$_deployer_ugv_help = ("
About: 1... clones the localhost submodules.
About: 2... == Your Options Are ==
ppc                : ~/deploy_ws/src/ugv/ppc
nuc                : ~/deploy_ws/src/ugv/nuc
hardware           : ~/deploy_ws/src/ugv/hardware (only available for basestation clone)
");

$_deployer_uav_help = ("
About: 1... clones the localhost submodules.
About: 2... == Your Options Are ==
core               : ~/deploy_ws/src/uav/core
hardware           : ~/deploy_ws/src/uav/hardware
");

$_deployer_basestation_help = ("
About: 1... clones the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
system76        : system76-pc laptop, for running both ugv & uav robots
laptop          : the uav specific drone laptop
");

$_deployer_system76_help = ("
About: 1... clones the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
ugv.ppc                 : ~/deploy_ws/src/ugv/ppc
ugv.nuc                 : ~/deploy_ws/src/ugv/nuc
ugv.hardware            : ~/deploy_ws/src/ugv/hardware
uav                : ~/deploy_ws/src/uav
uav.core                : ~/deploy_ws/src/uav/core
uav.hardware            : ~/deploy_ws/src/uav/hardware
");

$_deployer_laptop_uav_help = ("
About: 1... clones the localhost intermediate (meta) repos (including the meta's lowest level submodule repos).
About: 2... == Your Options Are ==
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
uav                : ~/deploy_ws/src/uav
uav.core                : ~/deploy_ws/src/uav/core
uav.hardware            : ~/deploy_ws/src/uav/hardware
");

$_deployer_slam_help = ("
slam.ugv.devel         : ~/deploy_ws/src/ugv/slam/devel (slam permssions required. only available for basestation clone)
slam.ugv.robot         : ~/deploy_ws/src/ugv/slam/robot (slam permssions required. only available for basestation clone)
slam.uav               : ~/deploy_ws/src/uav/slam (slam permssions required)
");

$_deployer_slam_ugv_help = ("
slam.ugv.devel         : ~/deploy_ws/src/ugv/slam/devel (slam permssions required. only available for basestation clone)
slam.ugv.robot         : ~/deploy_ws/src/ugv/slam/robot (slam permssions required. only available for basestation clone)
");
$_deployer_slam_uav_help = ("
slam.uav               : ~/deploy_ws/src/uav/slam (slam permssions required)
");

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_git_clone_help = ({
  id      => "clone",
  help    => $_deployer_system_help,
},{
  id      => "localhost",
  help    => $_deployer_localhost_help,
},{
  id      => "clone.localhost.ugv",
  help    => $_deployer_ugv_help,
},{
  id      => "slam",
  help    => $_deployer_slam_help,
},{
  id      => "slam",
  help    => $_deployer_slam_help,
},{
  id      => "slam.ugv",
  help    => $_deployer_slam_ugv_help,
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
  id      => "basestation.system76.ugv",
  help    => $_deployer_ugv_help,
},{
  id      => "basestation.system76.uav",
  help    => $_deployer_uav_help,
},{
  id      => "basestation.laptop",
  help    => $_deployer_laptop_uav_help,
},{
  id      => "basestation.laptop.uav",
  help    => $_deployer_uav_help,
});
