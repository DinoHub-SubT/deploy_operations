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

# TODO: dynamically create this for the different robots, to not hard-code as much...
my @_deployer     = (

  # ////////////////////////////////////////////////////////////////////////////
  # Azure

  ### ugvs ###

  # ugv1 general
  "azure.ugv.transfer.to",
  "azure.ugv.catkin.build",
  "azure.ugv.catkin.clean",
  "azure.ugv.docker.shell",
  "azure.ugv.docker.rm",
  "azure.ugv.docker.stop",
  "azure.ugv.docker.registry.pull",

  # ugv1
  "azure.ugv.ugv1.transfer.to",
  "azure.ugv.ugv1.catkin.build",
  "azure.ugv.ugv1.catkin.clean",
  "azure.ugv.ugv1.docker.shell",
  "azure.ugv.ugv1.docker.rm",
  "azure.ugv.ugv1.docker.stop",
  "azure.ugv.ugv1.docker.registry.pull",

  # ugv2
  "azure.ugv.ugv2.transfer.to",
  "azure.ugv.ugv2.catkin.build",
  "azure.ugv.ugv2.catkin.clean",
  "azure.ugv.ugv2.docker.shell",
  "azure.ugv.ugv2.docker.rm",
  "azure.ugv.ugv2.docker.stop",
  "azure.ugv.ugv2.docker.registry.pull",

  # ugv3
  "azure.ugv.ugv3.transfer.to",
  "azure.ugv.ugv3.catkin.build",
  "azure.ugv.ugv3.catkin.clean",
  "azure.ugv.ugv3.docker.shell",
  "azure.ugv.ugv3.docker.rm",
  "azure.ugv.ugv3.docker.stop",
  "azure.ugv.ugv3.docker.registry.pull",

  ### uavs ###

  # uav general
  "azure.uav.transfer.to",
  "azure.uav.catkin.build",
  "azure.uav.catkin.clean",
  "azure.uav.docker.shell",
  "azure.uav.docker.rm",
  "azure.uav.docker.stop",
  "azure.uav.docker.registry.pull",

  # uav1
  "azure.uav.uav1.transfer.to",
  "azure.uav.uav1.catkin.build",
  "azure.uav.uav1.catkin.clean",
  "azure.uav.uav1.docker.shell",
  "azure.uav.uav1.docker.rm",
  "azure.uav.uav1.docker.stop",
  "azure.uav.uav1.docker.registry.pull",

  # uav2
  "azure.uav.uav2.transfer.to",
  "azure.uav.uav2.catkin.build",
  "azure.uav.uav2.catkin.clean",
  "azure.uav.uav2.docker.shell",
  "azure.uav.uav2.docker.rm",
  "azure.uav.uav2.docker.stop",
  "azure.uav.uav2.docker.registry.pull",

  # uav3
  "azure.uav.uav3.transfer.to",
  "azure.uav.uav3.catkin.build",
  "azure.uav.uav3.catkin.clean",
  "azure.uav.uav3.docker.shell",
  "azure.uav.uav3.docker.rm",
  "azure.uav.uav3.docker.stop",
  "azure.uav.uav3.docker.registry.pull",

  # uav4
  "azure.uav.uav4.transfer.to",
  "azure.uav.uav4.catkin.build",
  "azure.uav.uav4.catkin.clean",
  "azure.uav.uav4.docker.shell",
  "azure.uav.uav4.docker.rm",
  "azure.uav.uav4.docker.stop",
  "azure.uav.uav4.docker.registry.pull",

  ### perception ###
  "azure.perception.perception1.transfer.to",
  "azure.perception.perception1.catkin.build",
  "azure.perception.perception1.catkin.clean",
  "azure.perception.perception1.docker.shell",
  "azure.perception.perception1.docker.rm",
  "azure.perception.perception1.docker.stop",
  "azure.perception.perception1.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # Robots

  ### ugvs ###

  # ugv general
  "robots.ugv.transfer.to",
  "robots.ugv.catkin.build",
  "robots.ugv.catkin.clean",
  "robots.ugv.docker.shell",
  "robots.ugv.docker.rm",
  "robots.ugv.docker.stop",
  "robots.ugv.docker.registry.pull",

  # ugv1 general
  "robots.ugv.ugv1.transfer.to",
  "robots.ugv.ugv1.catkin.build",
  "robots.ugv.ugv1.catkin.clean",
  "robots.ugv.ugv1.docker.shell",
  "robots.ugv.ugv1.docker.rm",
  "robots.ugv.ugv1.docker.stop",
  "robots.ugv.ugv1.docker.registry.pull",

  # ugv1:ppc
  "robots.ugv.ugv1.ppc.transfer.to",
  "robots.ugv.ugv1.ppc.catkin.build",
  "robots.ugv.ugv1.ppc.catkin.clean",
  "robots.ugv.ugv1.ppc.docker.shell",
  "robots.ugv.ugv1.ppc.docker.rm",
  "robots.ugv.ugv1.ppc.docker.stop",
  "robots.ugv.ugv1.ppc.docker.registry.pull",

  # ugv1:nuc
  "robots.ugv.ugv1.nuc.transfer.to",
  "robots.ugv.ugv1.nuc.catkin.build",
  "robots.ugv.ugv1.nuc.catkin.clean",
  "robots.ugv.ugv1.nuc.docker.shell",
  "robots.ugv.ugv1.nuc.docker.rm",
  "robots.ugv.ugv1.nuc.docker.stop",
  "robots.ugv.ugv1.nuc.docker.registry.pull",

  # ugv1:xavier
  "robots.ugv.ugv1.xavier.transfer.to",
  "robots.ugv.ugv1.xavier.catkin.build",
  "robots.ugv.ugv1.xavier.catkin.clean",
  "robots.ugv.ugv1.xavier.docker.shell",
  "robots.ugv.ugv1.xavier.docker.rm",
  "robots.ugv.ugv1.xavier.docker.stop",
  "robots.ugv.ugv1.xavier.docker.registry.pull",

  # ugv2 general
  "robots.ugv.ugv2.transfer.to",
  "robots.ugv.ugv2.catkin.build",
  "robots.ugv.ugv2.catkin.clean",
  "robots.ugv.ugv2.docker.shell",
  "robots.ugv.ugv2.docker.rm",
  "robots.ugv.ugv2.docker.stop",
  "robots.ugv.ugv2.docker.registry.pull",

  # ugv2:ppc
  "robots.ugv.ugv2.ppc.transfer.to",
  "robots.ugv.ugv2.ppc.catkin.build",
  "robots.ugv.ugv2.ppc.catkin.clean",
  "robots.ugv.ugv2.ppc.docker.shell",
  "robots.ugv.ugv2.ppc.docker.rm",
  "robots.ugv.ugv2.ppc.docker.stop",
  "robots.ugv.ugv2.ppc.docker.registry.pull",

  # ugv2:nuc
  "robots.ugv.ugv2.nuc.transfer.to",
  "robots.ugv.ugv2.nuc.catkin.build",
  "robots.ugv.ugv2.nuc.catkin.clean",
  "robots.ugv.ugv2.nuc.docker.shell",
  "robots.ugv.ugv2.nuc.docker.rm",
  "robots.ugv.ugv2.nuc.docker.stop",
  "robots.ugv.ugv2.nuc.docker.registry.pull",

  # ugv2:xavier
  "robots.ugv.ugv2.xavier.transfer.to",
  "robots.ugv.ugv2.xavier.catkin.build",
  "robots.ugv.ugv2.xavier.catkin.clean",
  "robots.ugv.ugv2.xavier.docker.shell",
  "robots.ugv.ugv2.xavier.docker.rm",
  "robots.ugv.ugv2.xavier.docker.stop",
  "robots.ugv.ugv2.xavier.docker.registry.pull",

  # ugv3 general
  "robots.ugv.ugv3.transfer.to",
  "robots.ugv.ugv3.catkin.build",
  "robots.ugv.ugv3.catkin.clean",
  "robots.ugv.ugv3.docker.shell",
  "robots.ugv.ugv3.docker.rm",
  "robots.ugv.ugv3.docker.stop",
  "robots.ugv.ugv3.docker.registry.pull",

  # ugv3:ppc
  "robots.ugv.ugv3.ppc.transfer.to",
  "robots.ugv.ugv3.ppc.catkin.build",
  "robots.ugv.ugv3.ppc.catkin.clean",
  "robots.ugv.ugv3.ppc.docker.shell",
  "robots.ugv.ugv3.ppc.docker.rm",
  "robots.ugv.ugv3.ppc.docker.stop",
  "robots.ugv.ugv3.ppc.docker.registry.pull",

  # ugv3:nuc
  "robots.ugv.ugv3.nuc.transfer.to",
  "robots.ugv.ugv3.nuc.catkin.build",
  "robots.ugv.ugv3.nuc.catkin.clean",
  "robots.ugv.ugv3.nuc.docker.shell",
  "robots.ugv.ugv3.nuc.docker.rm",
  "robots.ugv.ugv3.nuc.docker.stop",
  "robots.ugv.ugv3.nuc.docker.registry.pull",

  # ugv3:xavier
  "robots.ugv.ugv3.xavier.transfer.to",
  "robots.ugv.ugv3.xavier.catkin.build",
  "robots.ugv.ugv3.xavier.catkin.clean",
  "robots.ugv.ugv3.xavier.docker.shell",
  "robots.ugv.ugv3.xavier.docker.rm",
  "robots.ugv.ugv3.xavier.docker.stop",
  "robots.ugv.ugv3.xavier.docker.registry.pull",

  ### uavs ###

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

# various deployer help messages...
my @_deployer_robots_help = (   # match for robots
  "basestation  : deployment subt on basestation.",
  "ugv          : deployment subt on ugv hardware robots.",
  "uav          : deployment subt on uav hardware robots."
);
my @_deployer_azure_help = (  # match for azure
  "ugv          : deployment subt ugv on azure VMs.",
  "uav          : deployment subt uav on azure VMs.",
  "basestation  : deployment subt basestation on azure VMs.",
  "perception   : deployment subt perception on azure VMs."
);
my @_deployer_robots_ugv_help = (  # match for robots.ugv
  "ugv1       : deployment subt on ugv1 robot.",
  "ugv2       : deployment subt on ugv2 robot.",
  "ugv3       : deployment subt on ugv3 robot."
);
my @_deployer_azure_ugv_help = ( # match for azure.ugv
  "ugv1       : deployment subt on ugv1 Azure VM.",
  "ugv2       : deployment subt on ugv2 Azure VM.",
  "ugv3       : deployment subt on ugv3 Azure VM."
);
my @_deployer_robots_uav_help = ( # match for robots.uav
  "ds1       : deployment subt on ds1 robot.",
  "ds2       : deployment subt on ds2 robot.",
  "ds3       : deployment subt on ds3 robot.",
  "ds4       : deployment subt on ds4 robot."
);
my @_deployer_azure_uav_help = ( # match for azure.uav
  "uav1       : deployment subt on uav1 Azure VM.",
  "uav2       : deployment subt on uav2 Azure VM.",
  "uav3       : deployment subt on uav3 Azure VM.",
  "uav4       : deployment subt on uav4 Azure VM."
);
my @_deployer_robots_ugv_computer_help = ( # match for robots.ugv.ugv
  "ppc       : ppc ugv robot computer (hardware, planning, comms).",
  "nuc       : nuc ugv robot computer (state estimation).",
  "xavier    : xavier ugv robot computer (perception)."
);
my @_deployer_commands_help = ( # match for robots.ugv.ugv*.[ppc ,nuc, xavier]
  "transfer.to  : transfers code from localhost to remote system.",
  "skel_t.to    : transfers code (slim & faster -- no .git transfer) from localhost to remote system.",
  "docker       : automated docker setup such as containers, images, registry pull",
  "catkin       : automated catkin build & clean for all catkin profiled workspaces."
);
my @_deployer_commands_docker_help = ( # match for *.docker
  "docker.shell                     : starts the docker container on the remote or local system.",
  "docker.rm                        : removes the docker container on the remote or local system.",
  "docker.stop                      : stops the docker container on the remote or local system.",
  "docker.registry.azure.pull       : pulls docker images from the azure registry to the remote or local system (needs internet).",
  "docker.registry.basestation.pull : pulls docker images from the basestation registry to the remote or local system (images need to already exist on the basestation)."
);

my @_deployer_commands_catkin_help = ( # match for *.catkin
  "catkin.build                     : catkin build (catkin profile workspace already pre-configured).",
  "catkin.clean                     : catkin clean (catkin profile workspace already pre-configured)."
);

# @brief check string equalities
sub chk_flag {
  my ($_flag, $_args) = @_;
  $_args =~ m/$_flag/ ? return 1 : return 0;
}

# @brief match the suffix of the target token
sub dregex {
  my ($_target,  $_suffix) = @_;
  my $_regex="(?<=^$_target).*";
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

} elsif (chk_flag($_func, "deployer_help") ) {
  # TODO
  foreach (@_deployer_robots_help) {
    print "$_\n";
  }

} else {
  print "";  # return empy string on failure
}

