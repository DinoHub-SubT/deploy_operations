#!/usr/local/bin/perl

package cmpl_git_pull;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_git_pull
  $_deployer_local_help
  @_git_pull_help
);

# these are exported by default.
our @EXPORT = qw(
  @_git_pull
  $_deployer_local_help
  @_git_pull_help
);

our (
  @_git_pull,
  $_deployer_local_help,
  @_git_pull_help
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (git pull) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////
@_git_pull     = (
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
About: 00... == pull ==
About: 01... pulls a 'group' of submodules, per system (basestation, localhost)
About: 02...    - example: localhost does not clone hardware, basestation clones hardware
About: 03... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 04...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 05...
About: 06... == Optional Flags ==
About: 07...
About: 08...   -p           : preview the deployer commands that will be run
About: 09...   -verbose     : show the exact (verbose) bash commands that will run
About: 10...
About: 11... == Your Options Are ==
About: 12...
localhost     : pulls the submodules for developing on a localhost.
basestation   : pulls the submodules for developing on one of the basestation laptops.
slam          : pulls the slam submodules (can be used on localhost or on basestation)
"
);

$_deployer_localhost_help = ("
About: 00... == pull localhost ==
About: 01... pull the localhost 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04...
About: 05... == Optional Flags ==
About: 06...
About: 07...   -p           : preview the deployer commands that will be run
About: 08...   -verbose     : show the exact (verbose) bash commands that will run
About: 09...
About: 10... == Your Options Are ==
About: 11...
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
About: 00... == pull ugv ==
About: 01... pull the ugv 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04...
About: 05... == Optional Flags ==
About: 06...
About: 07...   -p           : preview the deployer commands that will be run
About: 08...   -verbose     : show the exact (verbose) bash commands that will run
About: 09...
About: 10... == Your Options Are ==
About: 11...
ppc                : ~/deploy_ws/src/ugv/ppc
nuc                : ~/deploy_ws/src/ugv/nuc
hardware           : ~/deploy_ws/src/ugv/hardware (only available for basestation pull)
");

$_deployer_uav_help = ("
About: 00... == pull uav ==
About: 01... pull the uav 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04...
About: 05... == Optional Flags ==
About: 06...
About: 07...   -p           : preview the deployer commands that will be run
About: 08...   -verbose     : show the exact (verbose) bash commands that will run
About: 09...
About: 10... == Your Options Are ==
About: 11...
core               : ~/deploy_ws/src/uav/core
hardware           : ~/deploy_ws/src/uav/hardware
");

$_deployer_basestation_help = ("
About: 00... == pull basestation ==
About: 01... pull the basestation 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04...
About: 05... == Optional Flags ==
About: 06...
About: 07...   -p           : preview the deployer commands that will be run
About: 08...   -verbose     : show the exact (verbose) bash commands that will run
About: 09...
About: 10... == Your Options Are ==
About: 11...
system76        : system76-pc laptop, for running both ugv & uav robots
laptop          : the uav specific drone laptop
");

$_deployer_system76_help = ("
About: 00... == pull basestation system76 (ugv, uav) ==
About: 01... pull the basestation system76 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04...
About: 05... == Optional Flags ==
About: 06...
About: 07...   -p           : preview the deployer commands that will be run
About: 08...   -verbose     : show the exact (verbose) bash commands that will run
About: 09...
About: 10... == Your Options Are ==
About: 11...
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
About: 00... == pull the slam submodules (loam, superodometry) ==
About: 01... pull the slam submodules (loam, superodometry) 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permi
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
basestation        : ~/deploy_ws/src/basestation
common             : ~/deploy_ws/src/common
perception         : ~/deploy_ws/src/perception
simulation         : ~/deploy_ws/src/simulation
uav                : ~/deploy_ws/src/uav
uav.core           : ~/deploy_ws/src/uav/core
uav.hardware       : ~/deploy_ws/src/uav/hardware
");

$_deployer_slam_help = ("
About: 00... == pull the slam submodules (loam, superodometry) ==
About: 01... pull the slam submodules (loam, superodometry) 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permi
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
ugv               : ~/deploy_ws/src/ugv/slam
uav               : ~/deploy_ws/src/uav/slam
");

$_deployer_slam_ugv_help = ("
About: 00... == pull the ugv slam submodules (loam, superodometry) ==
About: 01... pull the slam submodules (loam, superodometry) 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permi
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
slam.ugv.devel         : ~/deploy_ws/src/ugv/slam/devel (slam submodules for localhost development -- does not go on robot)
slam.ugv.robot         : ~/deploy_ws/src/ugv/slam/robot (slam submodules for ugv robot -- very special permission! USE DEVEL unless you KNOW you want the robot one.)
");
$_deployer_slam_uav_help = ("
About: 00... == pull the slam uav submodules (loam, superodometry) ==
About: 01... pull the slam submodules (loam, superodometry) 'group' submodules
About: 02... intermediate meta repo's submodules are fetched & integrated into the local submodule's checked-out branch
About: 03...    - i.e. any checked out a branch in the intermediate repo WILL NOT BE CHANGED.
About: 04... - slam submodules have special permissions -- that is why they are separate commands.
About: 05... - please make sure you have permissions to clone (notify maintainer if you need permi
About: 06...
About: 07... == Optional Flags ==
About: 08...
About: 09...   -p           : preview the deployer commands that will be run
About: 10...   -verbose     : show the exact (verbose) bash commands that will run
About: 11...
About: 12... == Your Options Are ==
About: 13...
slam.uav               : ~/deploy_ws/src/uav/slam (slam permssions required)
");

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_git_pull_help = ({
  id      => "pull",
  help    => $_deployer_system_help,
},{
  id      => "localhost",
  help    => $_deployer_localhost_help,
},{
  id      => "localhost.ugv",
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
