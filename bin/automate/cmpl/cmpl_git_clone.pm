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
About: 00... == clone ==
About: 01... clone submodules, per system (basestation, localhost)
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
localhost     : clone the submodules for developing on a localhost.
basestation   : clone the submodules for developing on one of the basestation laptops.
slam          : clone the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 00... == clone localhost ==
About: 01... clone submodules into the empty directories.
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
ugv.ppc            : ~/deploy_ws/src/ugv/ppc
ugv.nuc            : ~/deploy_ws/src/ugv/nuc
uav                : ~/deploy_ws/src/uav
uav.core           : ~/deploy_ws/src/uav/core
uav.hardware       : ~/deploy_ws/src/uav/hardware
");

$_deployer_ugv_help = ("
About: 00... == clone ugv ==
About: 01... clone submodules into the empty directories.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
ppc                : ~/deploy_ws/src/ugv/ppc
nuc                : ~/deploy_ws/src/ugv/nuc
hardware           : ~/deploy_ws/src/ugv/hardware (only available for basestation clone)
");

$_deployer_uav_help = ("
About: 00... == clone uav ==
About: 01... clone submodules into the empty directories.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
core               : ~/deploy_ws/src/uav/core
hardware           : ~/deploy_ws/src/uav/hardware
");

$_deployer_basestation_help = ("
About: 00... == clone basestation ==
About: 01... clone submodules into the empty directories.
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
About: 00... == clone basestation ==
About: 01... clone submodules into the empty directories.
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
ugv.ppc            : ~/deploy_ws/src/ugv/ppc
ugv.nuc            : ~/deploy_ws/src/ugv/nuc
ugv.hardware       : ~/deploy_ws/src/ugv/hardware
uav                : ~/deploy_ws/src/uav
uav.core                : ~/deploy_ws/src/uav/core
uav.hardware            : ~/deploy_ws/src/uav/hardware
");

$_deployer_laptop_uav_help = ("
About: 00... == clone basestation ==
About: 01... clone submodules into the empty directories.
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
uav.core           : ~/deploy_ws/src/uav/core
uav.hardware       : ~/deploy_ws/src/uav/hardware
");

$_deployer_slam_help = ("
About: 00... == clone the slam submodules (loam, superodometry) ==
About: 01... clone submodules into the empty directories.
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
About: 00... == clone the ugv slam submodules (loam, superodometry) ==
About: 01... clone submodules into the empty directories.
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
About: 00... == clone the uav slam submodules (loam, superodometry) ==
About: 01... clone submodules into the empty directories.
About: 02... == Optional Flags ==
About: 03...
About: 04...   -p           : preview the deployer commands that will be run
About: 05...   -verbose     : show the exact (verbose) bash commands that will run
About: 06...
About: 07... == Your Options Are ==
About: 08...
uav               : ~/deploy_ws/src/uav/slam (slam permssions required)
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
