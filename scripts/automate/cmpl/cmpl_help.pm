#!/usr/local/bin/perl#!/usr/local/bin/perl

package cmpl_help;
use Exporter;
use FindBin;
use cmpl_utils;
use Env;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////
our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  $_help_title
  format_help_str
  create_help
  get_help
  get_tutorial
);

# these are exported by default.
our @EXPORT = qw(
  $_help_title
  format_help_str
  create_help
  get_help
  get_tutorial
);

# //////////////////////////////////////////////////////////////////////////////
# @brief setup various help messages
# //////////////////////////////////////////////////////////////////////////////


our $_help_title = "About: 01... == SubT ==
About: 02... DARPA Subterranean (SubT) Challenge: rapidly map, navigate, search, and exploit complex underground environments, including tunnel systems, urban underground, and cave networks.
About: 03...
About: 04... HowTo:
About: 05...  - Press 'Tab' once, to preview a list of completed word options.
About: 06...  - Input a tab-complete word, from the preview list of completed words.
About: 07...  - Press '.', TAB to preview the next list of next available deployer actions.
About: 08...  - Press SPACE, TAB to show the help message and preview words (for your current completion match).
About: 09... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU SELECT THE NEXT KEYWORD (i.e. press backspace to show tab-complete list)
";

our $_help_flags = "
About: 11...
About: 12... == Optional Flags ==
About: 13...
About: 14...   -p           : preview the deployer commands that will be run
About: 15...   -verbose     : show the exact (verbose) bash commands that will run
About: 16...
About: 17... == Your Tab-Completed Word Options Are ==
About: 18...
";

our %_help_main = (
  # -- deployer --
  local       => "laptop simulation deployment, including all types of platforms deployments (basestation, ugv, uav) and multi-robot simulation.",
  azure       => "azure (remote) virtual machines, including all types of platforms deployments (basestation, ugv, uav).",
  robots      => "basestation (local) and robot (local, remote) computers deployments.",
  # general robots (or other infrastructure)
  basestation => "basestation local simulation or robot GUI deployment.",
  ugv         => "ugv local simulation or robots planning-pc, nuc, xavier deployment.",
  uav         => "uav local simulation or robots ds, canary deployment.",
  docker      => "general docker shortcuts.",
  # ugv on simulation or robots
  ugv1        => "ugv1 local simulation or robots planning-pc, nuc, xavier deployment.",
  ugv2        => "ugv2 local simulation or robots planning-pc, nuc, xavier deployment.",
  ugv3        => "ugv3 local simulation or robots planning-pc, nuc, xavier deployment.",
  # ugv on robots
  ppc         => "ugv planning-pc -- comms, planning ugv deployment.",
  nuc         => "ugv nuc -- state estimation, wifi detection ugv deployment.",
  xavier      => "ugv xavier -- object detection, perception detection ugv deployment.",
  # uav on robots
  ds1         => "ds1 robot ds deployment.",
  ds2         => "ds2 robot ds deployment.",
  ds3         => "ds3 robot ds deployment.",
  ds4         => "ds4 robot ds deployment.",
  # uav on simulation
  uav1         => "uav1 localhost simulation deployment (multi-robot simuation available).",
  uav2         => "uav2 localhost simulation deployment (multi-robot simuation available).",
  uav3         => "uav3 localhost simulation deployment (multi-robot simuation available).",
  uav4         => "uav4 localhost simulation deployment (multi-robot simuation available).",
  # workspaces
  melodic       => "ros melodic base docker setup -- common base image shared by all images.",
  core          => "main core setup, docker and catkin -- for all types of platforms (basestation, ugv, uav).",
  super             => "superodometry docker image and catkin workspace setup -- layered child image for some core setups.",
  perception        => "perception object detection  docker image and catkin workspace setup.",
  slam              => "slam docker image and catkin workspace -- loam or superodometry (optional outside docker).",
  wifi              => "wifi object detection catkin workspace (runs outside of docker).",
  # action:  catkin
  catkin_build    => "build the catkin workspace",
  catkin_clean    => "clean the catkin workspace",
  # action:  docker
  docker_make             => "build docker images",
  docker_shell_start      => "start docker containers",
  docker_shell_stop       => "stop docker containers",
  docker_shell_rm         => "remove docker containers",
  docker_registry_push    => "push docker images to remote registry",
  docker_registry_pull    => "pull docker images from remote registry",
  # action: transfer
  sync_transfer_to    => "build the core catkin workspace",
  sync_skel_to_to    => "clean the catkin workspace",

  # -- terraform --
  init     => "initializes subt's terraform setup with the correct tfstate file",
  cert     => "creates the vpn ca and user certifcations for creating an Azure VPN connection",
  plan     => "terraform plan (dry run) args are passed to terraform.",
  apply    => "terraform apply in the azurebooks/subt directory, args are passed to terraform.",
  mkvpn    => "creates the vpn needed to access azure (both through terraform and with network manager",
  rmvpn    => "removes the vpn needed to access azure (both through terraform and with network manager.",
  start    => "starts any or all VMs on Azure",
  stop     => "stops any or all VMs on Azure",
  destroy  => "destroys all Azure resources",
  monitor  => "monitor utils for Azure resources",
  env      => "install your user's terraform bash or zsh environment variables.",
  list     => "lists the power status of virtual machines.",

  # -- git --
  all_reset               => "resets all 2-level, 3-level submodules, respective to the 1-level commit (as DETACHED HEAD).",
  all_pull                => "pulls submodule updates, respective to the 2-level branch checkout (must be on a branch).",
  all_clean               => "clean all uncommitted changes, in 2-level meta and 3-levels submodules",
  all_rm                  => "remove (deinitializes) the 2-level meta and all 3-level submodules",
  all_ignore              => "ignore all catkin files in 2-level meta",
  all_unignore            => "ignore all catkin files in 2-level meta",

  common_meta             => "meta commands: git actions available for 2-level meta 'common'.",
  common_submodules       => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'common.",
  basestation_meta        => "meta commands: git actions available for 2-level meta 'basestation'",
  basestation_submodules  => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'basestation.",
  simulation_meta         => "meta commands: git actions available for 2-level meta 'simulation'",
  simulation_submodules   => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'simulation.",
  subt_launch_meta        => "meta commands: git actions available for 3-level meta 'subt_launch'",
  subt_launch_submodules  => "submodule commands: git actions available for 3-level 'subt_launch'.",

  ugv_meta                => "meta commands: git actions available for 2-level meta 'ugv'",
  ugv_ppc_submodules      => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'ugv.",
  ugv_nuc_submodules      => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'ugv.",
  ugv_hardware_submodules => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'ugv.",
  ugv_slam_submodules     => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'ugv.",

  uav_meta                => "meta commands: git actions available for 2-level meta 'uav'",
  uav_core_submodules     => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'uav.",
  uav_hardware_submodules => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'uav.",

  perception_meta         => "meta commands: git actions available for 2-level meta 'perception'",
  perception_submodules   => "submodule commands: git actions available for 3-level submodules found in 2-level meta 'perception.",

  meta_checkout           => "checkout a specific branch in 2-level meta",
  meta_ignore             => "ignore all catkin files in 2-level meta",
  meta_unignore           => "ignore all catkin files in 2-level meta",
  submodules_clean        => "clean all uncommitted changes, in 2-level meta and 3-levels submodules",
  submodules_pull         => "pull the latest updates in 2-level meta (must be on a branch)",
  submodules_reset        => "reset 2-level meta to the commit associated with 1-level",
  submodules_rm           => "remove (deinitializes) the 2-level meta and all 3-level submodules",

  # -- tools --
  probe_ssh        => "shows which configured ssh connections are are available to connect.",
  probe_teamviewer => "shows which teamviewer connections are are available to connect.",
  rdp              => "establish a rdp (rdesktop) session with an Azure VM.",
  snapshot         => "creates a snapshot logfile of deploy repo submodules.",
  verify_ops       => "verify all operations tools are functional.",
);

our %_help_tutorial = (
  local         => "laptop simulation deployment, including all types of platforms deployments (basestation, ugv, uav) and multi-robot simulation.",
  azure         => "azure (remote) virtual machines, including all types of platforms deployments (basestation, ugv, uav).",
  robots        => "basestation (local) and robot (local, remote) computers deployments.",
  operations    => "how to update operations -- terraform, ansible, configurations, dockerfiles, etc (i.e. updates in operations dir)",

  basestation   => "Tutorials on how to setup basestatation for localhost simulation or actual basestation for robots.",
  ugv_ugv1      => "Tutorials on how to setup ugv1 for localhost (or azure) simulation. This will include multi-robot simulation setup.",
  ugv_ugv2      => "Tutorials on how to setup ugv2 for localhost (or azure) simulation. This will include multi-robot simulation setup.",
  ugv_ugv3      => "Tutorials on how to setup ugv3 for localhost (or azure) simulation. This will include multi-robot simulation setup.",

  ugv_ugv1_ppc  => "Tutorials on how to setup robot ugv1, for ppc comptuer.",
  ugv_ugv2_ppc  => "Tutorials on how to setup robot ugv2, for ppc comptuer.",
  ugv_ugv3_ppc  => "Tutorials on how to setup robot ugv3, for ppc comptuer.",

  ugv_ugv1_nuc  => "Tutorials on how to setup robot ugv1, for nuc comptuer.",
  ugv_ugv2_nuc  => "Tutorials on how to setup robot ugv2, for nuc comptuer.",
  ugv_ugv3_nuc  => "Tutorials on how to setup robot ugv3, for nuc comptuer.",

  ugv_ugv1_xavier  => "Tutorials on how to setup robot ugv1, for xavier comptuer.",
  ugv_ugv2_xavier  => "Tutorials on how to setup robot ugv2, for xavier comptuer.",
  ugv_ugv3_xavier  => "Tutorials on how to setup robot ugv3, for xavier comptuer.",

  uav_uav1  => "Tutorials on how to setup uav1 for localhost (or azure) simulation. This will include multi-robot simulation setup.",
  uav_uav2  => "Tutorials on how to setup uav2 for localhost (or azure) simulation. This will include multi-robot simulation setup.",,
  uav_uav3  => "Tutorials on how to setup uav3 for localhost (or azure) simulation. This will include multi-robot simulation setup.",,
  uav_uav4  => "Tutorials on how to setup uav4 for localhost (or azure) simulation. This will include multi-robot simulation setup.",,

  uav_ds1  => "Tutorials on how to setup robot ds1.",
  uav_ds2  => "Tutorials on how to setup robot ds2.",
  uav_ds3  => "Tutorials on how to setup robot ds3.",
  uav_ds4  => "Tutorials on how to setup robot ds4.",
);

# //////////////////////////////////////////////////////////////////////////////
# @brief create the help messages
# //////////////////////////////////////////////////////////////////////////////

# @brief create help -- internal helper
sub _create_help {
  my %word_description = %{$_[0]};
  my @keyword = @{$_[1]};
  my $_help_msg;
  foreach $word (@keyword) {
    $_help_msg .= format_help_str($word, %word_description);
  }
  return $_help_msg;
}

# @brief create the 'main', tab-completion help message
sub get_help {
  @keyword = @_;
  return _create_help(\%_help_main, \@keyword);
}

# @brief create the 'main', tab-completion help message
sub get_tutorial {
  @keyword = @_;
  return _create_help(\%_help_tutorial, \@keyword);
}

# //////////////////////////////////////////////////////////////////////////////
# @brief general wrappers
# //////////////////////////////////////////////////////////////////////////////

# @brief convert keywords, with '_' as deliminator to '.' as deliminator.
sub format_help_str {
  my ($_name, %_hash ) = @_;
  # convert any underscores to dots
  (my $fmt_name = $_name) =~ s/\_/\./g;
  # format output help description print
  return sprintf("%-30s %00s \n", "$fmt_name", $_hash{"$_name"} );
}

# @brief create full tab-completion help message
sub create_help {
  my ($_append_msg) = @_;
  # append the header & body help message
  my $_help_msg = $_help_title . $_help_flags . $_append_msg;
  # crate newline, or wont show help
  newline();
  return $_help_msg;
}
