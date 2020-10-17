#!/usr/local/bin/perl

package cmpl_git_reset;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_git_reset
  $_deployer_local_help
  @_git_reset_help
);

# these are exported by default.
our @EXPORT = qw(
  @_git_reset
  $_deployer_local_help
  @_git_reset_help
);

our (
  @_git_reset,
  $_deployer_local_help,
  @_git_reset_help
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (git reset) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////
@_git_reset     = (
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
About: 00... == reset ==
About: 01... resets a 'group' of submodules, per system (basestation, localhost)
About: 02...    - example: localhost does not clone hardware, basestation clones hardware
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
    localhost     : resets the submodules for developing on a localhost.
    basestation   : resets the submodules for developing on one of the basestation laptops.
    slam          : resets the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 00... == reset localhost ==
About: 01... resets the localhost 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
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
About: 00... == reset ugv ==
About: 01... resets the ugv 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
ppc                : ~/deploy_ws/src/ugv/ppc
nuc                : ~/deploy_ws/src/ugv/nuc
hardware           : ~/deploy_ws/src/ugv/hardware (only available for basestation reset)
");

$_deployer_uav_help = ("
About: 00... == reset uav ==
About: 01... resets the uav 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
core               : ~/deploy_ws/src/uav/core
hardware           : ~/deploy_ws/src/uav/hardware
");

$_deployer_basestation_help = ("
About: 00... == reset basestation ==
About: 01... resets the basestation 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
system76        : system76-pc laptop, for running both ugv & uav robots
laptop          : the uav specific drone laptop
");

$_deployer_system76_help = ("
About: 00... == reset basestation system76 (ugv, uav) ==
About: 01... resets the basestation 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
ugv                : ~/deploy_ws/src/ugv
ugv.ppc            : ~/deploy_ws/src/ugv/ppc
ugv.nuc            : ~/deploy_ws/src/ugv/nuc
ugv.hardware       : ~/deploy_ws/src/ugv/hardware
uav                : ~/deploy_ws/src/uav
uav.core           : ~/deploy_ws/src/uav/core
uav.hardware       : ~/deploy_ws/src/uav/hardware
");

$_deployer_laptop_uav_help = ("
About: 00... == reset basestation laptop (uav only laptop) ==
About: 01... resets the basestation 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
uav                : ~/deploy_ws/src/uav
uav.core           : ~/deploy_ws/src/uav/core
uav.hardware       : ~/deploy_ws/src/uav/hardware
");

$_deployer_slam_help = ("
About: 00... == resets the slam submodules (loam, superodometry) ==
About: 01... resets the basestation 'group' submodules
About: 02... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permissions)
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
ugv         : ~/deploy_ws/src/ugv/slam
uav         : ~/deploy_ws/src/uav/slam
");

$_deployer_slam_ugv_help = ("
About: 00... == resets the slam ugv submodules (loam, superodometry) ==
About: 01... resets the basestation 'group' submodules
About: 02... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permissions)
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
devel         : ~/deploy_ws/src/ugv/slam/devel (slam submodules for localhost development -- does not go on robot)
robot         : ~/deploy_ws/src/ugv/slam/robot (slam submodules for ugv robot -- very special permission! USE DEVEL unless you KNOW you want the robot one.)
");

$_deployer_slam_uav_help = ("
About: 00... == resets the slam uav submodules (loam, superodometry) ==
About: 01... resets the basestation 'group' submodules
About: 03... intermediate meta repo's submodules are reset to its DEATACHED HEAD.
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL BE RESET to its HEAD commit.
About: 05... - slam submodules have special permissions -- that is why they are separate commands.
About: 06... - please make sure you have permissions to clone (notify maintainer if you need permissions)
About: 07...
About: 08... == Optional Flags ==
About: 09...
About: 10...   -p           : preview the deployer commands that will be run
About: 11...   -verbose     : show the exact (verbose) bash commands that will run
About: 12...
About: 13... == Your Options Are ==
About: 14...
uav               : ~/deploy_ws/src/uav/slam (slam permssions required)
");

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_git_reset_help = ({
  id      => "reset",
  help    => $_deployer_system_help,
},{
  id      => "localhost",
  help    => $_deployer_localhost_help,
},{
  id      => "localhost.ugv",
  help    => $_deployer_ugv_help,
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
