#!/usr/local/bin/perl

my @_subt         = ( "cloud", "deployer", "git", "tools", "update", "help" );
my @_git          = ( "status", "sync", "clone", "rm", "reset", "clean", "pr", "help" );
my @_git_status   = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );
my @_git_sync     = ( "deploy", "basestation", "common", "perception", "simulation", "ugv", "uav",
                      "launch", "help" );
my @_git_clone    = ( "basestation", "common", "perception", "simulation", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");
my @_cloud        = ( "terraform", "ansible", "help" );
my @_cloud_terra  = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" );
my @_cloud_ani    = ( "-az", "-r", "-l", "-b", "-p" );
my @_tools        = ( "ssh", "teamviewer", "rdp", "snapshot" );
my @_deployer     = (
  # ////////////////////////////////////////////////////////////////////////////
  # UGVs
  # ugv1 general
  "robots.ugv.transfer.to",
  "robots.ugv.catkin.build",
  "robots.ugv.catkin.clean",
  "robots.ugv.docker.shell",
  "robots.ugv.docker.rm",
  "robots.ugv.docker.stop",
  "robots.ugv.docker.registry.pull",

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

# @brief check string equalities
sub chk_flag {
  my ($_flag, $_args) = @_;
  $_args =~ m/$_flag/ ? return 1 : return 0;
}

# @brief match the suffix of the target token
sub dregex {
  my ($_target,  $_suffix) = @_;
  my $_regex="(?<=$_target).*";
  $_suffix =~ m/$_regex/;
  return $&;
}

# @brief deployer regex matcher, main entrypoint
sub deploy_matcher {
  my ($_target) = @_, $_match;
  foreach my $_deploy (@_deployer) {
    my $_suffix_match = dregex($_target, $_deploy);
    if (! $_suffix_match eq "") {
      $_match="$_match $_target$_suffix_match";
    }
  }
  return $_match;
}

# @brief match the suffix of the target token
sub gregex {
  my ($_target,  $_str) = @_;
  my $_regex="^$_target.*.*?";
  $_str =~ m/$_regex/;
  return $&;
}

sub general_matcher {
  my ($_target, @_subcommands) = @_, $_result;
  foreach my $_check (@_subcommands) {
    my $_match = gregex($_target, $_check);
    if (! $_match eq "") {
      $_result="$_result $_match";
    }
  }
  return $_result
}

# //////////////////////////////////////////////////////////////////////////////
# @brief main entrypoint
# //////////////////////////////////////////////////////////////////////////////
my ($_func, $_target) = @ARGV;

# match subcommands for each top command type
if (chk_flag($_func, "subt")  ) {
  print general_matcher($_target, @_subt);

} elsif (chk_flag($_func, "git")  ) {
  print general_matcher($_target, @_git);

} elsif (chk_flag($_func, "git_status")  ) {
  print general_matcher($_target, @_git_status);

} elsif (chk_flag($_func, "git_sync")  ) {
  print general_matcher($_target, @_git_sync);

} elsif (chk_flag($_func, "git_clone")  ) {
  print general_matcher($_target, @_git_clone);

} elsif (chk_flag($_func, "cloud")  ) {
  print general_matcher($_target, @_cloud);

} elsif (chk_flag($_func, "cloud_terra")  ) {
  print general_matcher($_target, @_cloud_terra);

} elsif (chk_flag($_func, "cloud_ani")  ) {
  print general_matcher($_target, @_cloud_ani);

} elsif (chk_flag($_func, "tools")  ) {
  print general_matcher($_target, @_tools);

} elsif (chk_flag($_func, "deployer") ) {
  # print $_, "\n" for split ' ', "$_match";
  print deploy_matcher($_target);

} else {
  print "";  # return empy string on failure
}

