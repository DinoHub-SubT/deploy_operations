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

  "slam.ugv.devel",
  "slam.ugv.robot",
  "slam.uav"
);

$_deployer_system_help = ("
About: 00... == clean ==
About: 01... cleans submodules from uncommitted changes, per system (basestation, localhost)
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
localhost     : cleans the submodules for developing on a localhost.
basestation   : cleans the submodules for developing on one of the basestation laptops.
slam          : cleans the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 00... == clean localhost ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
uav                : ~/deploy_ws/src/uav
");

$_deployer_basestation_help = ("
About: 00... == clean basestation ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
system76        : system76-pc laptop, for running both ugv & uav robots
laptop          : the uav specific drone laptop
");

$_deployer_system76_help = ("
About: 00... == clean basestation system76 (ugv, uav) ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
uav                : ~/deploy_ws/src/uav
");

$_deployer_laptop_uav_help = ("
About: 00... == clean basestation laptop (uav only) ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
uav                : ~/deploy_ws/src/uav
");

$_deployer_slam_help = ("
About: 00... == clean the slam submodules (loam, superodometry) ==
About: 01... cleans submodules from uncommitted changes.
About: 02... - slam submodules have special permissions -- that is why they are separate commands.
About: 03... - please make sure you have permissions to clone (notify maintainer if you need permissions)
About: 04... == Optional Flags ==
About: 05...
About: 06...   -p           : preview the deployer commands that will be run
About: 07...   -verbose     : show the exact (verbose) bash commands that will run
About: 08...
About: 09... == Your Options Are ==
About: 10...
ugv         : ~/deploy_ws/src/ugv/slam
uav         : ~/deploy_ws/src/uav/slam
");

$_deployer_slam_ugv_help = ("
About: 00... == clean the ugv slam submodules (loam, superodometry) ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
devel         : ~/deploy_ws/src/ugv/slam/devel (slam submodules for localhost development -- does not go on robot)
robot         : ~/deploy_ws/src/ugv/slam/robot (slam submodules for ugv robot -- very special permission! USE DEVEL unless you KNOW you want the robot one.)
");

$_deployer_slam_uav_help = ("
About: 00... == clean the uav slam submodules (loam, superodometry) ==
About: 01... cleans submodules from uncommitted changes.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
uav               : ~/deploy_ws/src/uav/slam
");


# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_git_clean_help = ({
  id      => "clean",
  help    => $_deployer_system_help,
},{
  id      => "localhost",
  help    => $_deployer_localhost_help,
},{
  id      => "basestation",
  help    => $_deployer_basestation_help,
},{
  id      => "basestation.system76",
  help    => $_deployer_system76_help,
},{
  id      => "basestation.laptop",
  help    => $_deployer_laptop_uav_help,
},{
  id      => "slam",
  help    => $_deployer_slam_help,
},{
  id      => "slam.ugv",
  help    => $_deployer_slam_ugv_help,
},{
  id      => "slam.uav",
  help    => $_deployer_slam_uav_help,
});
