#!/usr/local/bin/perl#!/usr/local/bin/perl

package cmpl_deployer;
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
  %_help_repository
  %_help_robots
  format_help_str
  create_help
  get_main_help
  get_catkin_help
  get_docker_help
  get_workspace_help
);

# these are exported by default.
our @EXPORT = qw(
  $_help_title
  %_help_repository
  %_help_robots
  format_help_str
  create_help
  get_main_help
  get_catkin_help
  get_docker_help
  get_workspace_help
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
  # @keyword = qw(local azure robots);
  @keyword = @_;
  return _create_help(\%_help_main, \@keyword);
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
