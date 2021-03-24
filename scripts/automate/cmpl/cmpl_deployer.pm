#!/usr/local/bin/perl

package cmpl_deployer;
use Exporter;
use FindBin;
use cmpl_utils;
use cmpl_help;
use Env;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_deployer
  @_deployer_help
);

# these are exported by default.
our @EXPORT = qw(
  @_deployer
  @_deployer_help
);

our (
  @_deployer,
  @_deployer_help
);

# read the deployer's cli matches (autogenerated by install-deployer.bash)
@_deployer = openfile("deployer.cmpl");

# //////////////////////////////////////////////////////////////////////////////
# @brief various help messages
# //////////////////////////////////////////////////////////////////////////////

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
# - TODO: update this matcher, to use better regex patterns...
@_deployer_help = ({

# -- main --
  id      => "deployer",
  help    => create_help(get_help(qw(local azure robots))),

# -- infrastructure types --
},{
  id      => "local",
  help    => create_help(get_help(qw(basestation ugv uav))),

},{
  id      => "azure",
  help    => create_help(get_help(qw(basestation ugv uav))),

},{
  id      => "robots",
  help    => create_help(get_help(qw(basestation ugv uav))),

# -- platforms --
},{
  id      => "ugv",
  help    => create_help(get_help(qw(ugv1 ugv2 ugv3))),

},{
  id      => "uav",
  help    => create_help(get_help(qw(ds1 ds2 ds3 ds4))),

},{
  id      => "basestation",
  help    => create_help(get_help(qw(melodic core))),

# -- robots --

},{
  id      => "local.ugv.ugv1",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "local.ugv.ugv2",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "local.ugv.ugv3",
  help    => create_help(get_help(qw(melodic core super perception))),


},{
  id      => "azure.ugv.ugv1",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "azure.ugv.ugv2",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "azure.ugv.ugv3",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "robots.ugv.ugv1",
  help    => create_help(get_help(qw(ppc nuc xavier))),

},{
  id      => "robots.ugv.ugv2",
  help    => create_help(get_help(qw(ppc nuc xavier))),

},{
  id      => "robots.ugv.ugv3",
  help    => create_help(get_help(qw(ppc nuc xavier))),

},{
  id      => "ppc",
  help    => create_help(get_help(qw(melodic core))),

},{
  id      => "nuc",
  help    => create_help(get_help(qw(melodic core super slam perception))),

},{
  id      => "xavier",
  help    => create_help(get_help(qw(melodic core))),

},{
  id      => "uav1",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "uav2",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "uav3",
  help    => create_help(get_help(qw(melodic core super perception))),

},{
  id      => "uav4",
  help    => create_help(get_help(qw(melodic core super perception))),

# -- workspace --

},{
  id      => "melodic",
  help    => create_help(get_help(qw(
    docker_make docker_shell_start docker_shell_stop docker_shell_rm docker_registry_push docker_registry_pull))),

},{
  id      => "core",
  help    => create_help(get_help(qw(
    catkin_build catkin_clean
    docker_make docker_shell_start docker_shell_stop docker_shell_rm docker_registry_push docker_registry_pull))),

},{
  id      => "super",
  help    => create_help(get_help(qw(
    catkin_build catkin_clean
    docker_make docker_shell_start docker_shell_stop docker_shell_rm docker_registry_push docker_registry_pull))),

},{
  id      => "perception",
  help    => create_help(get_help(qw(
    catkin_build catkin_clean
    docker_make docker_shell_start docker_shell_stop docker_shell_rm docker_registry_push docker_registry_pull))),

# -- actions --

},{
  id      => "catkin",
  help    => create_help(get_help(qw(catkin_build catkin_clean))),

},{
  id      => "docker",
  help    => create_help(get_help(qw(
    docker_make docker_shell_start docker_shell_stop docker_shell_rm docker_registry_push docker_registry_pull))),
},{
  id      => "make",
  help    => create_help(get_help(qw(
    docker_make docker_shell_start docker_shell_stop docker_shell_rm))),
},{
  id      => "shell",
  help    => create_help(get_help(qw(
    docker_shell_start docker_shell_stop docker_shell_rm))),
},{
  id      => "start",
  help    => create_help(get_help(qw(
    docker_shell_start docker_shell_stop docker_shell_rm))),
},{
  id      => "stop",
  help    => create_help(get_help(qw(
    docker_shell_start docker_shell_stop docker_shell_rm))),
},{
  id      => "rm",
  help    => create_help(get_help(qw(
    docker_shell_start docker_shell_stop docker_shell_rm))),
},{
  id      => "registry",
  help    => create_help(get_help(qw(docker_registry_push docker_registry_pull))),
},{
  id      => "push",
  help    => create_help(get_help(qw(docker_registry_push docker_registry_pull))),
},{
  id      => "pull",
  help    => create_help(get_help(qw(docker_registry_push docker_registry_pull))),

},{
  id      => "skel_to",
  help    => create_help(get_help(qw(sync_skel_to_to sync_transfer_to))),

},{
  id      => "transfer",
  help    => create_help(get_help(qw(sync_skel_to_to sync_transfer_to))),


# TODO: build workspaces: ugv_build <- need to filter this... (any matches between ugv*build)

});
