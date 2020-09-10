#!/usr/local/bin/perl

my @_deployer = (
  # ////////////////////////////////////////////////////////////////////////////
  # UGV1

  # ugv1 general
  "robots.ugv.ugv1.transfer.to",
  "robots.ugv.ugv1.catkin.build",
  "robots.ugv.ugv1.catkin.clean",
  "robots.ugv.ugv1.docker.shell",
  "robots.ugv.ugv1.docker.rm",
  "robots.ugv.ugv1.docker.stop",
  "robots.ugv.ugv1.docker.registry.pull",

  # UGV1:ppc
  "robots.ugv.ugv1.ppc.transfer.to",
  "robots.ugv.ugv1.ppc.catkin.build",
  "robots.ugv.ugv1.ppc.catkin.clean",
  "robots.ugv.ugv1.ppc.docker.shell",
  "robots.ugv.ugv1.ppc.docker.rm",
  "robots.ugv.ugv1.ppc.docker.stop",
  "robots.ugv.ugv1.ppc.docker.registry.pull",

  # UGV1:nuc
  "robots.ugv.ugv1.nuc.transfer.to",
  "robots.ugv.ugv1.nuc.catkin.build",
  "robots.ugv.ugv1.nuc.catkin.clean",
  "robots.ugv.ugv1.nuc.docker.shell",
  "robots.ugv.ugv1.nuc.docker.rm",
  "robots.ugv.ugv1.nuc.docker.stop",
  "robots.ugv.ugv1.nuc.docker.registry.pull",

  # UGV1:xavier
  "robots.ugv.ugv1.xavier.transfer.to",
  "robots.ugv.ugv1.xavier.catkin.build",
  "robots.ugv.ugv1.xavier.catkin.clean",
  "robots.ugv.ugv1.xavier.docker.shell",
  "robots.ugv.ugv1.xavier.docker.rm",
  "robots.ugv.ugv1.xavier.docker.stop",
  "robots.ugv.ugv1.xavier.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # UGV2

  # ugv2 general
  "robots.ugv.ugv2.transfer.to",
  "robots.ugv.ugv2.catkin.build",
  "robots.ugv.ugv2.catkin.clean",
  "robots.ugv.ugv2.docker.shell",
  "robots.ugv.ugv2.docker.rm",
  "robots.ugv.ugv2.docker.stop",
  "robots.ugv.ugv2.docker.registry.pull",

  # UGV2:ppc
  "robots.ugv.ugv2.ppc.transfer.to",
  "robots.ugv.ugv2.ppc.catkin.build",
  "robots.ugv.ugv2.ppc.catkin.clean",
  "robots.ugv.ugv2.ppc.docker.shell",
  "robots.ugv.ugv2.ppc.docker.rm",
  "robots.ugv.ugv2.ppc.docker.stop",
  "robots.ugv.ugv2.ppc.docker.registry.pull",

  # UGV2:nuc
  "robots.ugv.ugv2.nuc.transfer.to",
  "robots.ugv.ugv2.nuc.catkin.build",
  "robots.ugv.ugv2.nuc.catkin.clean",
  "robots.ugv.ugv2.nuc.docker.shell",
  "robots.ugv.ugv2.nuc.docker.rm",
  "robots.ugv.ugv2.nuc.docker.stop",
  "robots.ugv.ugv2.nuc.docker.registry.pull",

  # UGV2:xavier
  "robots.ugv.ugv2.xavier.transfer.to",
  "robots.ugv.ugv2.xavier.catkin.build",
  "robots.ugv.ugv2.xavier.catkin.clean",
  "robots.ugv.ugv2.xavier.docker.shell",
  "robots.ugv.ugv2.xavier.docker.rm",
  "robots.ugv.ugv2.xavier.docker.stop",
  "robots.ugv.ugv2.xavier.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # UGV3

  # ugv3 general
  "robots.ugv.ugv3.transfer.to",
  "robots.ugv.ugv3.catkin.build",
  "robots.ugv.ugv3.catkin.clean",
  "robots.ugv.ugv3.docker.shell",
  "robots.ugv.ugv3.docker.rm",
  "robots.ugv.ugv3.docker.stop",
  "robots.ugv.ugv3.docker.registry.pull",

  # UGV2:ppc
  "robots.ugv.ugv3.ppc.transfer.to",
  "robots.ugv.ugv3.ppc.catkin.build",
  "robots.ugv.ugv3.ppc.catkin.clean",
  "robots.ugv.ugv3.ppc.docker.shell",
  "robots.ugv.ugv3.ppc.docker.rm",
  "robots.ugv.ugv3.ppc.docker.stop",
  "robots.ugv.ugv3.ppc.docker.registry.pull",

  # UGV2:nuc
  "robots.ugv.ugv3.nuc.transfer.to",
  "robots.ugv.ugv3.nuc.catkin.build",
  "robots.ugv.ugv3.nuc.catkin.clean",
  "robots.ugv.ugv3.nuc.docker.shell",
  "robots.ugv.ugv3.nuc.docker.rm",
  "robots.ugv.ugv3.nuc.docker.stop",
  "robots.ugv.ugv3.nuc.docker.registry.pull",

  # UGV2:xavier
  "robots.ugv.ugv3.xavier.transfer.to",
  "robots.ugv.ugv3.xavier.catkin.build",
  "robots.ugv.ugv3.xavier.catkin.clean",
  "robots.ugv.ugv3.xavier.docker.shell",
  "robots.ugv.ugv3.xavier.docker.rm",
  "robots.ugv.ugv3.xavier.docker.stop",
  "robots.ugv.ugv3.xavier.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # UAV

  # uav1
  "robots.uav.ds1.transfer.to",
  "robots.uav.ds1.catkin.build",
  "robots.uav.ds1.catkin.clean",
  "robots.uav.ds1.docker.shell",
  "robots.uav.ds1.docker.rm",
  "robots.uav.ds1.docker.stop",
  "robots.uav.ds1.docker.registry.pull",

  # uav2
  "robots.uav.ds2.transfer.to",
  "robots.uav.ds2.catkin.build",
  "robots.uav.ds2.catkin.clean",
  "robots.uav.ds2.docker.shell",
  "robots.uav.ds2.docker.rm",
  "robots.uav.ds2.docker.stop",
  "robots.uav.ds2.docker.registry.pull",

  # uav3
  "robots.uav.ds3.transfer.to",
  "robots.uav.ds3.catkin.build",
  "robots.uav.ds3.catkin.clean",
  "robots.uav.ds3.docker.shell",
  "robots.uav.ds3.docker.rm",
  "robots.uav.ds3.docker.stop",
  "robots.uav.ds3.docker.registry.pull",

  # uav4
  "robots.uav.ds4.transfer.to",
  "robots.uav.ds4.catkin.build",
  "robots.uav.ds4.catkin.clean",
  "robots.uav.ds4.docker.shell",
  "robots.uav.ds4.docker.rm",
  "robots.uav.ds4.docker.stop",
  "robots.uav.ds4.docker.registry.pull"
);

# //////////////////////////////////////////////////////////////////////////////
# @brief match the suffix of the target token
# //////////////////////////////////////////////////////////////////////////////
sub smatch {
  my ($_target,  $_suffix) = @_;
  my $_regex="(?<=$_target).*";
  $_suffix =~ m/$_regex/;
  return $&;
}

# //////////////////////////////////////////////////////////////////////////////
# @brief match the prefix of already matched suffix
# //////////////////////////////////////////////////////////////////////////////
sub pmatch {
  my ($_suffix) = @_;
  my $_prefix=$_suffix;
  my $_prefix =~ m/^([^\.]+)/;
  return $&;
}

sub chk_flag {
  my ($_flag, $_args) = @_;
  $_args =~ /$$_flag/ ? return 1 : return 0;
}

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer regex matcher, main entrypoint
# //////////////////////////////////////////////////////////////////////////////
sub main_deploy {
  my ($_target) = @_, $_match;
  foreach my $_deploy (@_deployer) {
    my $_suffix_match = smatch($_target, $_deploy);
    if (! $_suffix_match eq "") {
      # my $_prefix_match = pmatch($_suffix_match);
      $_match="$_match $_target$_suffix_match";
    }
  }
  return $_match;
}

# //////////////////////////////////////////////////////////////////////////////
# @brief main entrypoint
# //////////////////////////////////////////////////////////////////////////////
my ($_func, $_target) = @ARGV;

if (chk_flag($_func, "deployer") ) {
  # print $_, "\n" for split ' ', "$_match";
  print main_deploy($_target);
}
