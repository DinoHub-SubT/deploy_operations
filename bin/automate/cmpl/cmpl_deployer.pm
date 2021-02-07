#!/usr/local/bin/perl

package cmpl_deployer;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_deployer
  $_deployer_local_help
  $_deployer_azure_help
  $_deployer_azure_ugv_help
  $_deployer_azure_uav_help
  $_deployer_robots_help
  $_deployer_robots_ugv_help
  $_deployer_robots_uav_help
  $_deployer_robots_ugv_computer_help
  $_deployer_commands_help
  $_deployer_commands_docker_help
  $_deployer_commands_catkin_help
  $_deployer_localhost_commands_help
  @_deployer_help_array
);

# these are exported by default.
our @EXPORT = qw(
  @_deployer
  $_deployer_local_help
  $_deployer_azure_help
  $_deployer_azure_ugv_help
  $_deployer_azure_uav_help
  $_deployer_robots_help
  $_deployer_robots_ugv_help
  $_deployer_robots_uav_help
  $_deployer_robots_ugv_computer_help
  $_deployer_commands_help
  $_deployer_commands_docker_help
  $_deployer_commands_catkin_help
  $_deployer_localhost_commands_help
  @_deployer_help_array
);

our (
  @_deployer,
  $_deployer_local_help,
  $_deployer_azure_help,
  $_deployer_azure_ugv_help,
  $_deployer_azure_uav_help,
  $_deployer_robots_help,
  $_deployer_robots_ugv_help,
  $_deployer_robots_uav_help,
  $_deployer_robots_ugv_computer_help,
  $_deployer_commands_help,
  $_deployer_commands_docker_help,
  $_deployer_commands_catkin_help,
  $_deployer_localhost_commands_help,
  @_deployer_help_array
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (general deployer) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////

@_deployer     = (

  # ////////////////////////////////////////////////////////////////////////////
  # Local

  # ugv1
  "local.docker.ops.clean",
  "local.docker.ops.stop",
  "local.docker.ops.rm",
  "local.docker.ops.prune",
  "local.docker.network.rm",
  "local.docker.network.create",

  # ugv1
  "local.ugv.ugv1.catkin.build",
  "local.ugv.ugv1.catkin.clean",
  "local.ugv.ugv1.docker.image",
  "local.ugv.ugv1.docker.shell",
  "local.ugv.ugv1.docker.shell.sim",
  "local.ugv.ugv1.docker.shell.ppc",
  "local.ugv.ugv1.docker.shell.nuc",
  "local.ugv.ugv1.docker.shell.super",
  "local.ugv.ugv1.docker.rm",
  "local.ugv.ugv1.docker.stop",
  "local.ugv.ugv1.docker.registry.pull",
  "local.ugv.ugv1.docker.registry.push",

  # ugv2
  "local.ugv.ugv2.catkin.build",
  "local.ugv.ugv2.catkin.clean",
  "local.ugv.ugv2.docker.image",
  "local.ugv.ugv2.docker.shell",
  "local.ugv.ugv2.docker.shell.sim",
  "local.ugv.ugv2.docker.shell.ppc",
  "local.ugv.ugv2.docker.shell.nuc",
  "local.ugv.ugv2.docker.shell.super",
  "local.ugv.ugv2.docker.rm",
  "local.ugv.ugv2.docker.stop",
  "local.ugv.ugv2.docker.registry.pull",
  "local.ugv.ugv2.docker.registry.push",

  # ugv3
  "local.ugv.ugv3.catkin.build",
  "local.ugv.ugv3.catkin.clean",
  "local.ugv.ugv3.docker.image",
  "local.ugv.ugv3.docker.shell",
  "local.ugv.ugv3.docker.shell.sim",
  "local.ugv.ugv3.docker.shell.ppc",
  "local.ugv.ugv3.docker.shell.nuc",
  "local.ugv.ugv3.docker.shell.super",
  "local.ugv.ugv3.docker.rm",
  "local.ugv.ugv3.docker.stop",
  "local.ugv.ugv3.docker.registry.pull",
  "local.ugv.ugv3.docker.registry.push",

  # uav1 - cpu
  "local.uav.uav1.cpu.catkin.px4",
  "local.uav.uav1.cpu.catkin.core.build",
  "local.uav.uav1.cpu.catkin.core.clean",
  "local.uav.uav1.cpu.catkin.perception.build",
  "local.uav.uav1.cpu.catkin.clean",
  "local.uav.uav1.cpu.docker.image.core",
  "local.uav.uav1.cpu.docker.image.perception",
  "local.uav.uav1.cpu.docker.image.super",
  "local.uav.uav1.cpu.docker.shell.core",
  "local.uav.uav1.cpu.docker.shell.perception",
  "local.uav.uav1.cpu.docker.shell.super",
  "local.uav.uav1.cpu.docker.rm",
  "local.uav.uav1.cpu.docker.stop",
  "local.uav.uav1.cpu.docker.registry.pull.core",
  "local.uav.uav1.cpu.docker.registry.pull.perception",
  "local.uav.uav1.cpu.docker.registry.pull.super",
  "local.uav.uav1.cpu.docker.registry.push.core",
  "local.uav.uav1.cpu.docker.registry.push.perception",
  "local.uav.uav1.cpu.docker.registry.push.super",

  "local.uav.uav1.gpu.catkin.px4",
  "local.uav.uav1.gpu.catkin.core.build",
  "local.uav.uav1.gpu.catkin.core.clean",
  "local.uav.uav1.gpu.catkin.perception.build",
  "local.uav.uav1.gpu.catkin.clean",
  "local.uav.uav1.gpu.docker.image.core",
  "local.uav.uav1.gpu.docker.image.perception",
  "local.uav.uav1.gpu.docker.image.super",
  "local.uav.uav1.gpu.docker.shell.core",
  "local.uav.uav1.gpu.docker.shell.perception",
  "local.uav.uav1.gpu.docker.shell.super",
  "local.uav.uav1.gpu.docker.rm",
  "local.uav.uav1.gpu.docker.stop",
  "local.uav.uav1.gpu.docker.registry.pull.core",
  "local.uav.uav1.gpu.docker.registry.pull.perception",
  "local.uav.uav1.gpu.docker.registry.pull.super",
  "local.uav.uav1.gpu.docker.registry.push.core",
  "local.uav.uav1.gpu.docker.registry.push.perception",
  "local.uav.uav1.gpu.docker.registry.push.super",

  # uav2 - cpu
  "local.uav.uav2.cpu.catkin.px4",
  "local.uav.uav2.cpu.catkin.core.build",
  "local.uav.uav2.cpu.catkin.core.clean",
  "local.uav.uav2.cpu.catkin.perception.build",
  "local.uav.uav2.cpu.catkin.clean",
  "local.uav.uav2.cpu.docker.image.core",
  "local.uav.uav2.cpu.docker.image.perception",
  "local.uav.uav2.cpu.docker.image.super",
  "local.uav.uav2.cpu.docker.shell.core",
  "local.uav.uav2.cpu.docker.shell.perception",
  "local.uav.uav2.cpu.docker.shell.super",
  "local.uav.uav2.cpu.docker.rm",
  "local.uav.uav2.cpu.docker.stop",
  "local.uav.uav2.cpu.docker.registry.pull.core",
  "local.uav.uav2.cpu.docker.registry.pull.perception",
  "local.uav.uav2.cpu.docker.registry.pull.super",
  "local.uav.uav2.cpu.docker.registry.push.core",
  "local.uav.uav2.cpu.docker.registry.push.perception",
  "local.uav.uav2.cpu.docker.registry.push.super",

  "local.uav.uav2.gpu.catkin.px4",
  "local.uav.uav2.gpu.catkin.core.build",
  "local.uav.uav2.gpu.catkin.core.clean",
  "local.uav.uav2.gpu.catkin.perception.build",
  "local.uav.uav2.gpu.catkin.clean",
  "local.uav.uav2.gpu.docker.image.core",
  "local.uav.uav2.gpu.docker.image.perception",
  "local.uav.uav2.gpu.docker.image.super",
  "local.uav.uav2.gpu.docker.shell.core",
  "local.uav.uav2.gpu.docker.shell.perception",
  "local.uav.uav2.gpu.docker.shell.super",
  "local.uav.uav2.gpu.docker.rm",
  "local.uav.uav2.gpu.docker.stop",
  "local.uav.uav2.gpu.docker.registry.pull.core",
  "local.uav.uav2.gpu.docker.registry.pull.perception",
  "local.uav.uav2.gpu.docker.registry.pull.super",
  "local.uav.uav2.gpu.docker.registry.push.core",
  "local.uav.uav2.gpu.docker.registry.push.perception",
  "local.uav.uav2.gpu.docker.registry.push.super",

  # uav3 - cpu
  "local.uav.uav3.cpu.catkin.px4",
  "local.uav.uav3.cpu.catkin.core.build",
  "local.uav.uav3.cpu.catkin.core.clean",
  "local.uav.uav3.cpu.catkin.perception.build",
  "local.uav.uav3.cpu.catkin.clean",
  "local.uav.uav3.cpu.docker.image.core",
  "local.uav.uav3.cpu.docker.image.perception",
  "local.uav.uav3.cpu.docker.image.super",
  "local.uav.uav3.cpu.docker.shell.core",
  "local.uav.uav3.cpu.docker.shell.perception",
  "local.uav.uav3.cpu.docker.shell.super",
  "local.uav.uav3.cpu.docker.rm",
  "local.uav.uav3.cpu.docker.stop",
  "local.uav.uav3.cpu.docker.registry.pull.core",
  "local.uav.uav3.cpu.docker.registry.pull.perception",
  "local.uav.uav3.cpu.docker.registry.pull.super",
  "local.uav.uav3.cpu.docker.registry.push.core",
  "local.uav.uav3.cpu.docker.registry.push.perception",
  "local.uav.uav3.cpu.docker.registry.push.super",

  "local.uav.uav3.gpu.catkin.px4",
  "local.uav.uav3.gpu.catkin.core.build",
  "local.uav.uav3.gpu.catkin.core.clean",
  "local.uav.uav3.gpu.catkin.perception.build",
  "local.uav.uav3.gpu.catkin.clean",
  "local.uav.uav3.gpu.docker.image.core",
  "local.uav.uav3.gpu.docker.image.perception",
  "local.uav.uav3.gpu.docker.image.super",
  "local.uav.uav3.gpu.docker.shell.core",
  "local.uav.uav3.gpu.docker.shell.perception",
  "local.uav.uav3.gpu.docker.shell.super",
  "local.uav.uav3.gpu.docker.rm",
  "local.uav.uav3.gpu.docker.stop",
  "local.uav.uav3.gpu.docker.registry.pull.core",
  "local.uav.uav3.gpu.docker.registry.pull.perception",
  "local.uav.uav3.gpu.docker.registry.pull.super",
  "local.uav.uav3.gpu.docker.registry.push.core",
  "local.uav.uav3.gpu.docker.registry.push.perception",
  "local.uav.uav3.gpu.docker.registry.push.super",

  # uav4 - cpu
  "local.uav.uav4.cpu.catkin.px4",
  "local.uav.uav4.cpu.catkin.core.build",
  "local.uav.uav4.cpu.catkin.core.clean",
  "local.uav.uav4.cpu.catkin.perception.build",
  "local.uav.uav4.cpu.catkin.clean",
  "local.uav.uav4.cpu.docker.image.core",
  "local.uav.uav4.cpu.docker.image.perception",
  "local.uav.uav4.cpu.docker.image.super",
  "local.uav.uav4.cpu.docker.shell.core",
  "local.uav.uav4.cpu.docker.shell.perception",
  "local.uav.uav4.cpu.docker.shell.super",
  "local.uav.uav4.cpu.docker.rm",
  "local.uav.uav4.cpu.docker.stop",
  "local.uav.uav4.cpu.docker.registry.pull.core",
  "local.uav.uav4.cpu.docker.registry.pull.perception",
  "local.uav.uav4.cpu.docker.registry.pull.super",
  "local.uav.uav4.cpu.docker.registry.push.core",
  "local.uav.uav4.cpu.docker.registry.push.perception",
  "local.uav.uav4.cpu.docker.registry.push.super",

  "local.uav.uav4.gpu.catkin.px4",
  "local.uav.uav4.gpu.catkin.core.build",
  "local.uav.uav4.gpu.catkin.core.clean",
  "local.uav.uav4.gpu.catkin.perception.build",
  "local.uav.uav4.gpu.catkin.clean",
  "local.uav.uav4.gpu.docker.image.core",
  "local.uav.uav4.gpu.docker.image.perception",
  "local.uav.uav4.gpu.docker.image.super",
  "local.uav.uav4.gpu.docker.shell.core",
  "local.uav.uav4.gpu.docker.shell.perception",
  "local.uav.uav4.gpu.docker.shell.super",
  "local.uav.uav4.gpu.docker.rm",
  "local.uav.uav4.gpu.docker.stop",
  "local.uav.uav4.gpu.docker.registry.pull.core",
  "local.uav.uav4.gpu.docker.registry.pull.perception",
  "local.uav.uav4.gpu.docker.registry.pull.super",
  "local.uav.uav4.gpu.docker.registry.push.core",
  "local.uav.uav4.gpu.docker.registry.push.perception",
  "local.uav.uav4.gpu.docker.registry.push.super",

  # perception
  "local.perception.catkin.build",
  "local.perception.catkin.clean",
  "local.perception.docker.image",
  "local.perception.docker.shell",
  "local.perception.docker.rm",
  "local.perception.docker.stop",
  "local.perception.docker.registry.pull",
  "local.perception.docker.registry.push",

  # basestation
  "local.basestation.catkin.build",
  "local.basestation.catkin.clean",
  "local.basestation.docker.image",
  "local.basestation.docker.shell",
  "local.basestation.docker.rm",
  "local.basestation.docker.stop",
  "local.basestation.docker.registry.pull",
  "local.basestation.docker.registry.push",

  # ////////////////////////////////////////////////////////////////////////////
  # Azure

  ### ugvs ###

  # ugv1 general
  "azure.ugv.transfer.to",
  "azure.ugv.skel_t.to",
  "azure.ugv.catkin.build",
  "azure.ugv.catkin.clean",
  "azure.ugv.docker.shell",
  "azure.ugv.docker.image",
  "azure.ugv.docker.rm",
  "azure.ugv.docker.stop",
  "azure.ugv.docker.registry.pull",

  # ugv1
  "azure.ugv.ugv1.transfer.to",
  "azure.ugv.ugv1.skel_t.to",
  "azure.ugv.ugv1.catkin.build",
  "azure.ugv.ugv1.catkin.clean",
  "azure.ugv.ugv1.docker.image",
  "azure.ugv.ugv1.docker.shell",
  "azure.ugv.ugv1.docker.rm",
  "azure.ugv.ugv1.docker.stop",
  "azure.ugv.ugv1.docker.registry.pull",

  # ugv2
  "azure.ugv.ugv2.transfer.to",
  "azure.ugv.ugv2.skel_to.to",
  "azure.ugv.ugv2.catkin.build",
  "azure.ugv.ugv2.catkin.clean",
  "azure.ugv.ugv2.docker.shell",
  "azure.ugv.ugv2.docker.image",
  "azure.ugv.ugv2.docker.rm",
  "azure.ugv.ugv2.docker.stop",
  "azure.ugv.ugv2.docker.registry.pull",

  # ugv3
  "azure.ugv.ugv3.transfer.to",
  "azure.ugv.ugv3.skel_t.to",
  "azure.ugv.ugv3.catkin.build",
  "azure.ugv.ugv3.catkin.clean",
  "azure.ugv.ugv3.docker.shell",
  "azure.ugv.ugv3.docker.image",
  "azure.ugv.ugv3.docker.rm",
  "azure.ugv.ugv3.docker.stop",
  "azure.ugv.ugv3.docker.registry.pull",

  ### uavs ###

  # uav general
  "azure.uav.transfer.to",
  "azure.uav.skel_t.to",
  "azure.uav.catkin.build",
  "azure.uav.catkin.clean",
  "azure.uav.docker.shell.core",
  "azure.uav.docker.shell.perception",
  "azure.uav.docker.shell.super",
  "azure.uav.docker.image.core",
  "azure.uav.docker.image.perception",
  "azure.uav.docker.image.super",
  "azure.uav.docker.rm",
  "azure.uav.docker.stop",
  "azure.uav.docker.registry.pull.core",
  "azure.uav.docker.registry.pull.perception",
  "azure.uav.docker.registry.pull.super",

  # uav1
  "azure.uav.uav1.transfer.to",
  "azure.uav.uav1.skel_t.to",
  "azure.uav.uav1.catkin.px4",
  "azure.uav.uav1.catkin.core.build",
  "azure.uav.uav1.catkin.core.clean",
  "azure.uav.uav1.docker.shell.core",
  "azure.uav.uav1.docker.shell.perception",
  "azure.uav.uav1.docker.shell.super",
  "azure.uav.uav1.docker.image.core",
  "azure.uav.uav1.docker.image.perception",
  "azure.uav.uav1.docker.image.super",
  "azure.uav.uav1.docker.rm",
  "azure.uav.uav1.docker.stop",
  "azure.uav.uav1.docker.registry.pull.core",
  "azure.uav.uav1.docker.registry.pull.perception",
  "azure.uav.uav1.docker.registry.pull.super",

  # uav2
  "azure.uav.uav2.transfer.to",
  "azure.uav.uav2.skel_t.to",
  "azure.uav.uav2.catkin.px4",
  "azure.uav.uav2.catkin.core.build",
  "azure.uav.uav2.catkin.core.clean",
  "azure.uav.uav2.docker.shell.core",
  "azure.uav.uav2.docker.shell.perception",
  "azure.uav.uav2.docker.shell.super",
  "azure.uav.uav2.docker.image.core",
  "azure.uav.uav2.docker.image.perception",
  "azure.uav.uav2.docker.image.super",
  "azure.uav.uav2.docker.rm",
  "azure.uav.uav2.docker.stop",
  "azure.uav.uav2.docker.registry.pull.core",
  "azure.uav.uav2.docker.registry.pull.perception",
  "azure.uav.uav2.docker.registry.pull.super",

  # uav3
  "azure.uav.uav3.transfer.to",
  "azure.uav.uav3.skel_t.to",
  "azure.uav.uav3.catkin.px4",
  "azure.uav.uav3.catkin.core.build",
  "azure.uav.uav3.catkin.core.clean",
  "azure.uav.uav3.docker.shell.core",
  "azure.uav.uav3.docker.shell.perception",
  "azure.uav.uav3.docker.shell.super",
  "azure.uav.uav3.docker.image.core",
  "azure.uav.uav3.docker.image.perception",
  "azure.uav.uav3.docker.image.super",
  "azure.uav.uav3.docker.rm",
  "azure.uav.uav3.docker.stop",
  "azure.uav.uav3.docker.registry.pull.core",
  "azure.uav.uav3.docker.registry.pull.perception",
  "azure.uav.uav3.docker.registry.pull.super",

  # uav4
  "azure.uav.uav4.transfer.to",
  "azure.uav.uav4.skel_t.to",
  "azure.uav.uav4.catkin.px4",
  "azure.uav.uav4.catkin.core.build",
  "azure.uav.uav4.catkin.core.clean",
  "azure.uav.uav4.docker.shell.core",
  "azure.uav.uav4.docker.shell.perception",
  "azure.uav.uav4.docker.shell.super",
  "azure.uav.uav4.docker.image.core",
  "azure.uav.uav4.docker.image.perception",
  "azure.uav.uav4.docker.image.super",
  "azure.uav.uav4.docker.rm",
  "azure.uav.uav4.docker.stop",
  "azure.uav.uav4.docker.registry.pull.core",
  "azure.uav.uav4.docker.registry.pull.perception",
  "azure.uav.uav4.docker.registry.pull.super",

  ### perception ###
  "azure.perception.perception1.transfer.to",
  "azure.perception.perception1.skel_t.to",
  "azure.perception.perception1.catkin.build",
  "azure.perception.perception1.catkin.clean",
  "azure.perception.perception1.docker.shell",
  "azure.perception.perception1.docker.image",
  "azure.perception.perception1.docker.rm",
  "azure.perception.perception1.docker.stop",
  "azure.perception.perception1.docker.registry.pull",

  # basestation
  "azure.basestation.transfer.to",
  "azure.basestation.skel_t.to",
  "azure.basestation.catkin.build",
  "azure.basestation.catkin.clean",
  "azure.basestation.docker.shell",
  "azure.basestation.docker.image",
  "azure.basestation.docker.rm",
  "azure.basestation.docker.stop",
  "azure.basestation.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # Robots

  ### ugvs ###

  # ugv general
  "robots.ugv.transfer.to",
  "robots.ugv.skel_t.to",
  "robots.ugv.catkin.build",
  "robots.ugv.catkin.clean",
  "robots.ugv.docker.shell",
  "robots.ugv.docker.image",
  "robots.ugv.docker.rm",
  "robots.ugv.docker.stop",
  "robots.ugv.docker.registry.azure.pull",
  "robots.ugv.docker.registry.basestation.pull",

  # ugv1 general
  "robots.ugv.ugv1.transfer.to",
  "robots.ugv.ugv1.skel_t.to",
  "robots.ugv.ugv1.catkin.build",
  "robots.ugv.ugv1.catkin.clean",
  "robots.ugv.ugv1.docker.shell",
  "robots.ugv.ugv1.docker.image",
  "robots.ugv.ugv1.docker.rm",
  "robots.ugv.ugv1.docker.stop",
  "robots.ugv.ugv1.docker.registry.azure.pull",
  "robots.ugv.ugv1.docker.registry.basestation.pull",

  # ugv1:ppc
  "robots.ugv.ugv1.ppc.transfer.to",
  "robots.ugv.ugv1.ppc.skel_t.to",
  "robots.ugv.ugv1.ppc.catkin.build",
  "robots.ugv.ugv1.ppc.catkin.clean",
  "robots.ugv.ugv1.ppc.docker.shell",
  "robots.ugv.ugv1.ppc.docker.image",
  "robots.ugv.ugv1.ppc.docker.rm",
  "robots.ugv.ugv1.ppc.docker.stop",
  "robots.ugv.ugv1.ppc.docker.registry.azure.pull",
  "robots.ugv.ugv1.ppc.docker.registry.basestation.pull",

  # ugv1:nuc
  "robots.ugv.ugv1.nuc.transfer.to",
  "robots.ugv.ugv1.nuc.skel_t.to",
  "robots.ugv.ugv1.nuc.catkin.build",
  "robots.ugv.ugv1.nuc.catkin.clean",
  "robots.ugv.ugv1.nuc.docker.shell",
  "robots.ugv.ugv1.nuc.docker.image",
  "robots.ugv.ugv1.nuc.docker.rm",
  "robots.ugv.ugv1.nuc.docker.stop",
  "robots.ugv.ugv1.nuc.docker.registry.azure.pull",
  "robots.ugv.ugv1.nuc.docker.registry.basestation.pull",

  # ugv1:xavier
  "robots.ugv.ugv1.xavier.transfer.to",
  "robots.ugv.ugv1.xavier.skel_t.to",
  "robots.ugv.ugv1.xavier.catkin.build",
  "robots.ugv.ugv1.xavier.catkin.clean",
  "robots.ugv.ugv1.xavier.docker.shell",
  "robots.ugv.ugv1.xavier.docker.image",
  "robots.ugv.ugv1.xavier.docker.rm",
  "robots.ugv.ugv1.xavier.docker.stop",
  "robots.ugv.ugv1.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv1.xavier.docker.registry.azure.push",
  "robots.ugv.ugv1.xavier.docker.registry.basestation.pull",

  # ugv2 general
  "robots.ugv.ugv2.transfer.to",
  "robots.ugv.ugv2.skel_t.to",
  "robots.ugv.ugv2.catkin.build",
  "robots.ugv.ugv2.catkin.clean",
  "robots.ugv.ugv2.docker.shell",
  "robots.ugv.ugv2.docker.image",
  "robots.ugv.ugv2.docker.rm",
  "robots.ugv.ugv2.docker.stop",
  "robots.ugv.ugv2.docker.registry.azure.pull",
  "robots.ugv.ugv2.docker.registry.basestation.pull",

  # ugv2:ppc
  "robots.ugv.ugv2.ppc.transfer.to",
  "robots.ugv.ugv2.ppc.skel_t.to",
  "robots.ugv.ugv2.ppc.catkin.build",
  "robots.ugv.ugv2.ppc.catkin.clean",
  "robots.ugv.ugv2.ppc.docker.shell",
  "robots.ugv.ugv2.ppc.docker.image",
  "robots.ugv.ugv2.ppc.docker.rm",
  "robots.ugv.ugv2.ppc.docker.stop",
  "robots.ugv.ugv2.ppc.docker.registry.azure.pull",
  "robots.ugv.ugv2.ppc.docker.registry.basestation.pull",

  # ugv2:nuc
  "robots.ugv.ugv2.nuc.transfer.to",
  "robots.ugv.ugv2.nuc.skel_t.to",
  "robots.ugv.ugv2.nuc.catkin.build",
  "robots.ugv.ugv2.nuc.catkin.clean",
  "robots.ugv.ugv2.nuc.docker.shell",
  "robots.ugv.ugv2.nuc.docker.image",
  "robots.ugv.ugv2.nuc.docker.rm",
  "robots.ugv.ugv2.nuc.docker.stop",
  "robots.ugv.ugv2.nuc.docker.registry.azure.pull",
  "robots.ugv.ugv2.nuc.docker.registry.basestation.pull",

  # ugv2:xavier
  "robots.ugv.ugv2.xavier.transfer.to",
  "robots.ugv.ugv2.xavier.skel_t.to",
  "robots.ugv.ugv2.xavier.catkin.build",
  "robots.ugv.ugv2.xavier.catkin.clean",
  "robots.ugv.ugv2.xavier.docker.shell",
  "robots.ugv.ugv2.xavier.docker.image",
  "robots.ugv.ugv2.xavier.docker.rm",
  "robots.ugv.ugv2.xavier.docker.stop",
  "robots.ugv.ugv2.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv2.xavier.docker.registry.azure.push",
  "robots.ugv.ugv2.xavier.docker.registry.basestation.pull",

  # ugv3 general
  "robots.ugv.ugv3.transfer.to",
  "robots.ugv.ugv3.skel_t.to",
  "robots.ugv.ugv3.catkin.build",
  "robots.ugv.ugv3.catkin.clean",
  "robots.ugv.ugv3.docker.shell",
  "robots.ugv.ugv3.docker.image",
  "robots.ugv.ugv3.docker.rm",
  "robots.ugv.ugv3.docker.stop",
  "robots.ugv.ugv3.docker.registry.azure.pull",
  "robots.ugv.ugv3.docker.registry.basestation.pull",

  # ugv3:ppc
  "robots.ugv.ugv3.ppc.transfer.to",
  "robots.ugv.ugv3.ppc.skel_t.to",
  "robots.ugv.ugv3.ppc.catkin.build",
  "robots.ugv.ugv3.ppc.catkin.clean",
  "robots.ugv.ugv3.ppc.docker.shell",
  "robots.ugv.ugv3.ppc.docker.image",
  "robots.ugv.ugv3.ppc.docker.rm",
  "robots.ugv.ugv3.ppc.docker.stop",
  "robots.ugv.ugv3.ppc.docker.registry.azure.pull",
  "robots.ugv.ugv3.ppc.docker.registry.basestation.pull",

  # ugv3:nuc
  "robots.ugv.ugv3.nuc.transfer.to",
  "robots.ugv.ugv3.nuc.skel_t.to",
  "robots.ugv.ugv3.nuc.catkin.build",
  "robots.ugv.ugv3.nuc.catkin.clean",
  "robots.ugv.ugv3.nuc.docker.shell",
  "robots.ugv.ugv3.nuc.docker.image",
  "robots.ugv.ugv3.nuc.docker.rm",
  "robots.ugv.ugv3.nuc.docker.stop",
  "robots.ugv.ugv3.nuc.docker.registry.azure.pull",
  "robots.ugv.ugv3.nuc.docker.registry.basestation.pull",

  # ugv3:xavier
  "robots.ugv.ugv3.xavier.transfer.to",
  "robots.ugv.ugv3.xavier.skel_t.to",
  "robots.ugv.ugv3.xavier.catkin.build",
  "robots.ugv.ugv3.xavier.catkin.clean",
  "robots.ugv.ugv3.xavier.docker.shell",
  "robots.ugv.ugv3.xavier.docker.image",
  "robots.ugv.ugv3.xavier.docker.rm",
  "robots.ugv.ugv3.xavier.docker.stop",
  "robots.ugv.ugv3.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv3.xavier.docker.registry.azure.push",
  "robots.ugv.ugv3.xavier.docker.registry.basestation.pull",

  ### uavs ###

  # uav1
  "robots.ds.ds1.transfer.to",
  "robots.ds.ds1.skel_t.to",
  "robots.ds.ds1.catkin.px4",
  "robots.ds.ds1.catkin.build",
  "robots.ds.ds1.catkin.clean",
  "robots.ds.ds1.catkin.core.build",
  "robots.ds.ds1.catkin.perception.build",
  "robots.ds.ds1.catkin.wifi.build",
  "robots.ds.ds1.catkin.core.clean",
  "robots.ds.ds1.catkin.perception.clean",
  "robots.ds.ds1.catkin.wifi.clean",
  "robots.ds.ds1.docker.shell.core",
  "robots.ds.ds1.docker.shell.perception",
  "robots.ds.ds1.docker.shell.super",
  "robots.ds.ds1.docker.image.core",
  "robots.ds.ds1.docker.image.perception",
  "robots.ds.ds1.docker.image.super",
  "robots.ds.ds1.docker.rm",
  "robots.ds.ds1.docker.stop",
  "robots.ds.ds1.docker.registry.azure.pull.core",
  "robots.ds.ds1.docker.registry.azure.pull.perception",
  "robots.ds.ds1.docker.registry.azure.pull.super",
  "robots.ds.ds1.docker.registry.basestation.pull.core",
  "robots.ds.ds1.docker.registry.basestation.pull.perception",
  "robots.ds.ds1.docker.registry.basestation.pull.super",

  # uav2
  "robots.ds.ds2.transfer.to",
  "robots.ds.ds2.skel_t.to",
  "robots.ds.ds2.catkin.px4",
  "robots.ds.ds2.catkin.build",
  "robots.ds.ds2.catkin.clean",
  "robots.ds.ds2.catkin.core.build",
  "robots.ds.ds2.catkin.core.clean",
  "robots.ds.ds2.catkin.perception.build",
  "robots.ds.ds2.catkin.wifi.build",
  "robots.ds.ds2.catkin.core.clean",
  "robots.ds.ds2.catkin.perception.clean",
  "robots.ds.ds2.catkin.wifi.clean",
  "robots.ds.ds2.docker.shell.core",
  "robots.ds.ds2.docker.shell.perception",
  "robots.ds.ds2.docker.shell.super",
  "robots.ds.ds2.docker.image.core",
  "robots.ds.ds2.docker.image.perception",
  "robots.ds.ds2.docker.image.super",
  "robots.ds.ds2.docker.rm",
  "robots.ds.ds2.docker.stop",
  "robots.ds.ds2.docker.registry.azure.pull.core",
  "robots.ds.ds2.docker.registry.azure.pull.perception",
  "robots.ds.ds2.docker.registry.azure.pull.super",
  "robots.ds.ds2.docker.registry.basestation.pull.core",
  "robots.ds.ds2.docker.registry.basestation.pull.perception",
  "robots.ds.ds2.docker.registry.basestation.pull.super",

  # uav3
  "robots.ds.ds3.transfer.to",
  "robots.ds.ds3.skel_t.to",
  "robots.ds.ds3.catkin.px4",
  "robots.ds.ds3.catkin.build",
  "robots.ds.ds3.catkin.clean",
  "robots.ds.ds3.catkin.core.build",
  "robots.ds.ds3.catkin.perception.build",
  "robots.ds.ds3.catkin.wifi.build",
  "robots.ds.ds3.catkin.core.clean",
  "robots.ds.ds3.catkin.perception.clean",
  "robots.ds.ds3.catkin.wifi.clean",
  "robots.ds.ds3.docker.shell.core",
  "robots.ds.ds3.docker.shell.perception",
  "robots.ds.ds3.docker.shell.super",
  "robots.ds.ds3.docker.image.core",
  "robots.ds.ds3.docker.image.perception",
  "robots.ds.ds3.docker.image.super",
  "robots.ds.ds3.docker.rm",
  "robots.ds.ds3.docker.stop",
  "robots.ds.ds3.docker.registry.azure.pull.core",
  "robots.ds.ds3.docker.registry.azure.pull.perception",
  "robots.ds.ds3.docker.registry.azure.pull.super",
  "robots.ds.ds3.docker.registry.basestation.pull.core",
  "robots.ds.ds3.docker.registry.basestation.pull.perception",
  "robots.ds.ds3.docker.registry.basestation.pull.super",

  # uav4
  "robots.ds.ds4.transfer.to",
  "robots.ds.ds4.skel_t.to",
  "robots.ds.ds4.catkin.px4",
  "robots.ds.ds4.catkin.build",
  "robots.ds.ds4.catkin.clean",
  "robots.ds.ds4.catkin.core.build",
  "robots.ds.ds4.catkin.perception.build",
  "robots.ds.ds4.catkin.wifi.build",
  "robots.ds.ds4.catkin.core.clean",
  "robots.ds.ds4.catkin.perception.clean",
  "robots.ds.ds4.catkin.wifi.clean",
  "robots.ds.ds4.docker.shell.core",
  "robots.ds.ds4.docker.shell.perception",
  "robots.ds.ds4.docker.shell.super",
  "robots.ds.ds4.docker.image.core",
  "robots.ds.ds4.docker.image.perception",
  "robots.ds.ds4.docker.image.super",
  "robots.ds.ds4.docker.rm",
  "robots.ds.ds4.docker.stop",
  "robots.ds.ds4.docker.registry.azure.pull.core",
  "robots.ds.ds4.docker.registry.azure.pull.perception",
  "robots.ds.ds4.docker.registry.azure.pull.super",
  "robots.ds.ds4.docker.registry.basestation.pull.core",
  "robots.ds.ds4.docker.registry.basestation.pull.perception",
  "robots.ds.ds4.docker.registry.basestation.pull.super",


  # basestation
  "robots.basestation.catkin.build",
  "robots.basestation.catkin.clean",
  "robots.basestation.docker.image",
  "robots.basestation.docker.shell",
  "robots.basestation.docker.rm",
  "robots.basestation.docker.stop",
  "robots.basestation.docker.registry.pull",
  "robots.basestation.docker.registry.push",
);

# //////////////////////////////////////////////////////////////////////////////
# @brief various help messages
# //////////////////////////////////////////////////////////////////////////////
# local
$_deployer_local_help = ("
About: 1... deploys subt to localhost.
About: 2... your localhost runs the different parts of the system, in their own containers.
About: 4... this includes ugv (ground robot), uav (drone), basestation (gui) and perception (objdet).
About: 6... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 7... == Your Options Are ==
ugv          : deployment subt ugv on azure VMs.
uav          : deployment subt uav on azure VMs.
basestation  : deployment subt basestation on azure VMs.
perception   : deployment subt perception on azure VMs"
);
$_local_robots_ugv_help = ("
About: 1... deploys subt to any one of the local 'robot' docker containers.
About: 2... the same deploy is installed on all ground robots.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == Your Options Are ==
Options:
ugv1       : deployment subt on ugv1 local docker container.
ugv2       : deployment subt on ugv2 local docker container.
ugv3       : deployment subt on ugv3 local docker container."
);
$_local_robots_uav_help = ("
About: 1... deploys subt to any one of the local 'robot' docker containers.
About: 2... the same deploy is installed on all drone robots.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == Your Options Are ==
uav1       : deployment subt on uav1 Azure VM.
uav2       : deployment subt on uav2 Azure VM.
uav3       : deployment subt on uav3 Azure VM.
uav4       : deployment subt on uav4 Azure VM."
);
# azure
$_deployer_azure_help = ("
About: 1... deploys subt to Azure Virtual Machines (VMs).
About: 2... different VMs run different parts of the system.
About: 4... this includes ugv (ground robot), uav (drone), basestation (gui) and perception (objdet).
About: 5... the different systems run their own gazebo, rviz, etc, but can all communication with each other.
About: 6... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 7... == Your Options Are ==
ugv          : deployment subt ugv on azure VMs.
uav          : deployment subt uav on azure VMs.
basestation  : deployment subt basestation on azure VMs.
perception   : deployment subt perception on azure VMs"
);
$_deployer_azure_ugv_help = ("
About: 1... deploys subt to any one of the remote 'ground robot' Azure VMs.
About: 2... the same deploy is installed on all ground robot VMs.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == Your Options Are ==
Options:
ugv1       : deployment subt on ugv1 Azure VM.
ugv2       : deployment subt on ugv2 Azure VM.
ugv3       : deployment subt on ugv3 Azure VM."
);
$_deployer_azure_uav_help = ("
About: 1... deploys subt to any one of the remote 'drone' Azure VMs.
About: 2... the same deploy is installed on all drone VMs.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == Your Options Are ==
uav1       : deployment subt on uav1 Azure VM.
uav2       : deployment subt on uav2 Azure VM.
uav3       : deployment subt on uav3 Azure VM.
uav4       : deployment subt on uav4 Azure VM."
);
# robots
$_deployer_robots_help = ("
About: 1... deploys subt to one of the remote hardware robots or laptop basestation.
About: 2... different types of robots (and basestation) run different parts of the code.
About: 3... the same deploy is installed on all systems.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == Your Options Are ==
basestation  : deployment subt on basestation.
ugv          : deployment subt on ugv hardware robots.
uav          : deployment subt on uav hardware robots."
);
$_deployer_robots_ugv_help = ("
About: 1... deploys subt to any one of the remote hardware ground robots.
About: 2... the ugvs have 3 different computers, to run different parts of the system.
About: 3... the same deploy is installed on all ground robots.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == Your Options Are ==
ugv1       : deployment subt on ugv1 robot.
ugv2       : deployment subt on ugv2 robot.
ugv3       : deployment subt on ugv3 robot."
);
$_deployer_robots_uav_help = ("
About: 1... deploys subt to any one of the remote hardware drones.
About: 2... the same deploy is installed on all drone robots.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == Your Options Are ==
ds1       : deployment subt on ds1 robot.
ds2       : deployment subt on ds2 robot.
ds3       : deployment subt on ds3 robot.
ds4       : deployment subt on ds4 robot."
);
$_deployer_robots_ugv_computer_help = ("
About: 1... deploys subt to any one of the remote hardware ground robots, to their specific computers.
About: 2... the ugvs have 3 different computers, to run different parts of the system.
About: 3... planning pc (ppc) runs the hardware, planning & comms stack.
About: 4... nuc runs state estimation stack.
About: 5... xavier runs perception stack.
About: 6... all three computers can communication with each other and can reach the basestation.
About: 7... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 8... == Your Options Are ==
ppc       : ppc ugv robot computer (hardware, planning, comms).
nuc       : nuc ugv robot computer (state estimation).
xavier    : xavier ugv robot computer (perception)."
);
# general commands
$_deployer_commands_help = ("
About: 1... general deployment operations commands.
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == Your Options Are ==
transfer.to  : transfers code from localhost to remote system (just an rsync).
skel_t.to    : transfers code (slim & faster -- no .git transfer) from localhost to remote system.
docker       : automated docker setup such as containers, images, registry pull.
catkin       : automated catkin build & clean for all catkin profiled workspaces."
);
$_deployer_commands_docker_help = ("
About: 1... general docker operation commands.
About: 2... you can add -p (preview) to show which deployment commands that will run.
About: 3... you can add -v (verbose) to show the exact shell commands that will be run.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == Your Options Are ==
image                     : builds the docker image directly on the system.
shell                     : starts the docker container on the remote or local system.
rm                        : removes the docker container on the remote or local system.
stop                      : stops the docker container on the remote or local system.
registry.azure.pull       : pulls docker images from the azure registry to the remote or local system (needs internet).
registry.basestation.pull : pulls docker images from the basestation registry to the remote or local system (images need to already exist on the basestation).
network                   : creating or removing a user-defined docker network."
);
$_deployer_commands_catkin_help = ("
About: 1... general catkin operation commands.
About: 2... you can add -p (preview) to show which deployment commands that will run.
About: 3... you can add -v (verbose) to show the exact shell commands that will be run.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == Your Options Are ==
build                     : catkin build (catkin profile workspace already pre-configured).
clean                     : catkin clean (catkin profile workspace already pre-configured)."
);
$_deployer_localhost_commands_help = ("
About: 1... general deployment operations commands.
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == Your Options Are ==
docker       : automated docker setup such as containers, images, registry pull.
catkin       : automated catkin build & clean for all catkin profiled workspaces."
);
$_deployer_type_commands_help = ("
About: 1... deploys the specific type of system dependencies (docker container enabled).
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == Your Options Are ==
cpu         : deploys subt using only the dependencies available for a CPU only system.
gpu         : deploys subt with dependencies optimized for a NVIDIA GPU available system."
);

$_deployer_uav_catkin_commands_help = ("
About: 1... general catkin commands, for difference types of catkin workspaces.
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == Your Options Are ==
clean         : cleans all the workspaces.
core          : builds or cleans the uav core workspace.
perception    : builds or cleans the uav perception workspace.
px4           : builds the px4 dependencies.
");

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
@_deployer_help_array = ({
  id      => "local",
  help    => $_deployer_local_help,
},{
  id      => "local.ugv",
  help    => $_local_robots_ugv_help,
},{
  id      => "local.ugv.ugv1",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "local.ugv.ugv2",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "local.ugv.ugv3",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "local.uav",
  help    => $_local_robots_uav_help,
},{
  id      => "local.uav.uav1",
  help    => $_deployer_type_commands_help,
},{
  id      => "local.uav.uav2",
  help    => $_deployer_type_commands_help,
},{
  id      => "local.uav.uav3",
  help    => $_deployer_type_commands_help,
},{
  id      => "local.uav.uav4",
  help    => $_deployer_type_commands_help,
},{
  id      => "local.basestation",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "local.percpetion",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "azure",
  help    => $_deployer_azure_help,
},{
  id      => "azure.ugv",
  help    => $_deployer_azure_ugv_help,
},{
  id      => "azure.ugv.ugv1",
  help    => $_deployer_commands_help,
},{
  id      => "azure.ugv.ugv2",
  help    => $_deployer_commands_help,
},{
  id      => "azure.ugv.ugv3",
  help    => $_deployer_commands_help,
},{
  id      => "azure.uav",
  help    => $_deployer_azure_uav_help,
},{
  id      => "azure.uav.uav1",
  help    => $_deployer_commands_help,
},{
  id      => "azure.uav.uav2",
  help    => $_deployer_commands_help,
},{
  id      => "azure.uav.uav3",
  help    => $_deployer_commands_help,
},{
  id      => "azure.uav.uav4",
  help    => $_deployer_commands_help,
},{
  id      => "robots",
  help    => $_deployer_robots_help
},{
  id      => "robots.ugv",
  help    => $_deployer_robots_ugv_help
},{
  id      => "robots.ugv.ugv1",
  help    => $_deployer_robots_ugv_computer_help
},{
  id      => "robots.ugv.ugv2",
  help    => $_deployer_robots_ugv_computer_help
},{
  id      => "robots.ugv.ugv3",
  help    => $_deployer_robots_ugv_computer_help
},{
  id      => "ppc",
  help    => $_deployer_commands_help
},{
  id      => "nuc",
  help    => $_deployer_commands_help
},{
  id      => "xavier",
  help    => $_deployer_commands_help
},{
  id      => "robots.uav.ds1",
  help    => $_deployer_commands_help
},{
  id      => "robots.uav.ds2",
  help    => $_deployer_commands_help
},{
  id      => "robots.uav.ds3",
  help    => $_deployer_commands_help
},{
  id      => "robots.uav.ds4",
  help    => $_deployer_commands_help
},{
  id      => "docker",
  help    => $_deployer_commands_docker_help
},{
  id      => "catkin",
  help    => $_deployer_uav_catkin_commands_help
},{
  id      => "catkin.core",
  help    => $ _deployer_commands_catkin_help
},{
  id      => "catkin.perception",
  help    => $_deployer_commands_catkin_help
},{
  id      => "cpu",
  help    => $_deployer_localhost_commands_help
},{
  id      => "gpu",
  help    => $_deployer_localhost_commands_help
});
