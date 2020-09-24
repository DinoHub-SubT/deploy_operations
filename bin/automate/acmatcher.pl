#!/usr/local/bin/perl

my @_subt         = ( "cloud", "deployer", "git", "tools", "update", "help" );

my @_git          = ( "status", "sync", "add", "clone", "rm", "reset", "clean", "pr", "help" );

my @_git_status   = ( "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

my @_git_sync     = ( "deploy", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

my @_git_add      = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );

my @_git_clone    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");

my @_git_reset    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");

my @_git_clean    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "uav", "help" );

my @_git_rm       = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");

my @_cloud        = ( "terraform", "ansible", "help" );

my @_cloud_terra  = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" , "destroy", 
                      "monitor" );

my @_cloud_ani    = ( "-az", "-r", "-l", "-b", "-p" );

my @_tools        = ( "ssh", "teamviewer", "rdp", "snapshot" );

# TODO: eventually get this from the py deployer...
my @_deployer     = (

  # ////////////////////////////////////////////////////////////////////////////
  # Local
  "local.ugv.catkin.build",
  "local.ugv.catkin.clean",
  "local.ugv.docker.shell",
  "local.ugv.docker.shell.sim",
  "local.ugv.docker.shell.ppc",
  "local.ugv.docker.shell.nuc",
  "local.ugv.docker.rm",
  "local.ugv.docker.stop",
  "local.ugv.docker.registry.pull",

  "local.uav.catkin.build",
  "local.uav.catkin.clean",
  "local.uav.docker.shell",
  "local.uav.docker.rm",
  "local.uav.docker.stop",
  "local.uav.docker.registry.pull",

  "local.perception.catkin.build",
  "local.perception.catkin.clean",
  "local.perception.docker.shell",
  "local.perception.docker.rm",
  "local.perception.docker.stop",
  "local.perception.docker.registry.pull",

  "local.basestation.catkin.build",
  "local.basestation.catkin.clean",
  "local.basestation.docker.shell",
  "local.basestation.docker.rm",
  "local.basestation.docker.stop",
  "local.basestation.docker.registry.pull",

  # ////////////////////////////////////////////////////////////////////////////
  # Azure

  ### ugvs ###

  # ugv1 general
  "azure.ugv.transfer.to",
  "azure.ugv.skel_t.to",
  "azure.ugv.catkin.build",
  "azure.ugv.catkin.clean",
  "azure.ugv.docker.shell",
  "azure.ugv.docker.rm",
  "azure.ugv.docker.stop",
  "azure.ugv.docker.registry.pull",

  # ugv1
  "azure.ugv.ugv1.transfer.to",
  "azure.ugv.ugv1.skel_t.to",
  "azure.ugv.ugv1.catkin.build",
  "azure.ugv.ugv1.catkin.clean",
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
  "azure.ugv.ugv2.docker.rm",
  "azure.ugv.ugv2.docker.stop",
  "azure.ugv.ugv2.docker.registry.pull",

  # ugv3
  "azure.ugv.ugv3.transfer.to",
  "azure.ugv.ugv3.skel_t.to",
  "azure.ugv.ugv3.catkin.build",
  "azure.ugv.ugv3.catkin.clean",
  "azure.ugv.ugv3.docker.shell",
  "azure.ugv.ugv3.docker.rm",
  "azure.ugv.ugv3.docker.stop",
  "azure.ugv.ugv3.docker.registry.pull",

  ### uavs ###

  # uav general
  "azure.uav.transfer.to",
  "azure.uav.skel_t.to",
  "azure.uav.catkin.build",
  "azure.uav.catkin.clean",
  "azure.uav.docker.shell",
  "azure.uav.docker.rm",
  "azure.uav.docker.stop",
  "azure.uav.docker.registry.pull",

  # uav1
  "azure.uav.uav1.transfer.to",
  "azure.uav.uav1.skel_t.to",
  "azure.uav.uav1.catkin.build",
  "azure.uav.uav1.catkin.clean",
  "azure.uav.uav1.docker.shell",
  "azure.uav.uav1.docker.rm",
  "azure.uav.uav1.docker.stop",
  "azure.uav.uav1.docker.registry.pull",

  # uav2
  "azure.uav.uav2.transfer.to",
  "azure.uav.uav2.skel_t.to",
  "azure.uav.uav2.catkin.build",
  "azure.uav.uav2.catkin.clean",
  "azure.uav.uav2.docker.shell",
  "azure.uav.uav2.docker.rm",
  "azure.uav.uav2.docker.stop",
  "azure.uav.uav2.docker.registry.pull",

  # uav3
  "azure.uav.uav3.transfer.to",
  "azure.uav.uav3.skel_t.to",
  "azure.uav.uav3.catkin.build",
  "azure.uav.uav3.catkin.clean",
  "azure.uav.uav3.docker.shell",
  "azure.uav.uav3.docker.rm",
  "azure.uav.uav3.docker.stop",
  "azure.uav.uav3.docker.registry.pull",

  # uav4
  "azure.uav.uav4.transfer.to",
  "azure.uav.uav4.skel_t.to",
  "azure.uav.uav4.catkin.build",
  "azure.uav.uav4.catkin.clean",
  "azure.uav.uav4.docker.shell",
  "azure.uav.uav4.docker.rm",
  "azure.uav.uav4.docker.stop",
  "azure.uav.uav4.docker.registry.pull",

  ### perception ###
  "azure.perception.perception1.transfer.to",
  "azure.perception.perception1.skel_t.to",
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
  "robots.ugv.skel_t.to",
  "robots.ugv.catkin.build",
  "robots.ugv.catkin.clean",
  "robots.ugv.docker.shell",
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
  "robots.ugv.ugv1.xavier.docker.rm",
  "robots.ugv.ugv1.xavier.docker.stop",
  "robots.ugv.ugv1.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv1.xavier.docker.registry.basestation.pull",

  # ugv2 general
  "robots.ugv.ugv2.transfer.to",
  "robots.ugv.ugv2.skel_t.to",
  "robots.ugv.ugv2.catkin.build",
  "robots.ugv.ugv2.catkin.clean",
  "robots.ugv.ugv2.docker.shell",
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
  "robots.ugv.ugv2.xavier.docker.rm",
  "robots.ugv.ugv2.xavier.docker.stop",
  "robots.ugv.ugv2.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv2.xavier.docker.registry.basestation.pull",

  # ugv3 general
  "robots.ugv.ugv3.transfer.to",
  "robots.ugv.ugv3.skel_t.to",
  "robots.ugv.ugv3.catkin.build",
  "robots.ugv.ugv3.catkin.clean",
  "robots.ugv.ugv3.docker.shell",
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
  "robots.ugv.ugv3.xavier.docker.rm",
  "robots.ugv.ugv3.xavier.docker.stop",
  "robots.ugv.ugv3.xavier.docker.registry.azure.pull",
  "robots.ugv.ugv3.xavier.docker.registry.basestation.pull",

  ### uavs ###

  # uav1
  "robots.uav.ds1.transfer.to",
  "robots.uav.ds1.skel_t.to",
  "robots.uav.ds1.catkin.build",
  "robots.uav.ds1.catkin.clean",
  "robots.uav.ds1.docker.shell",
  "robots.uav.ds1.docker.rm",
  "robots.uav.ds1.docker.stop",
  "robots.uav.ds1.docker.registry.azure.pull",
  "robots.uav.ds1.docker.registry.basestation.pull",

  # uav2
  "robots.uav.ds2.transfer.to",
  "robots.uav.ds2.skel_t.to",
  "robots.uav.ds2.catkin.build",
  "robots.uav.ds2.catkin.clean",
  "robots.uav.ds2.docker.shell",
  "robots.uav.ds2.docker.rm",
  "robots.uav.ds2.docker.stop",
  "robots.uav.ds2.docker.registry.azure.pull",
  "robots.uav.ds2.docker.registry.basestation.pull",

  # uav3
  "robots.uav.ds3.transfer.to",
  "robots.uav.ds3.skel_t.to",
  "robots.uav.ds3.catkin.build",
  "robots.uav.ds3.catkin.clean",
  "robots.uav.ds3.docker.shell",
  "robots.uav.ds3.docker.rm",
  "robots.uav.ds3.docker.stop",
  "robots.uav.ds3.docker.registry.azure.pull",
  "robots.uav.ds3.docker.registry.basestation.pull",

  # uav4
  "robots.uav.ds4.transfer.to",
  "robots.uav.ds4.skel_t.to",
  "robots.uav.ds4.catkin.build",
  "robots.uav.ds4.catkin.clean",
  "robots.uav.ds4.docker.shell",
  "robots.uav.ds4.docker.rm",
  "robots.uav.ds4.docker.stop",
  "robots.uav.ds4.docker.registry.azure.pull",
  "robots.uav.ds4.docker.registry.basestation.pull"
);

# //////////////////////////////////////////////////////////////////////////////
# @brief various help messages
# //////////////////////////////////////////////////////////////////////////////
# local
my $_deployer_local_help = ("
About: 1... deploys subt to localhost.
About: 2... your localhost runs the different parts of the system, in their own containers.
About: 4... this includes ugv (ground robot), uav (drone), basestation (gui) and perception (objdet).
About: 6... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 7... == You Options Are ==
ugv          : deployment subt ugv on azure VMs.
uav          : deployment subt uav on azure VMs.
basestation  : deployment subt basestation on azure VMs.
perception   : deployment subt perception on azure VMs"
);
# azure
my $_deployer_azure_help = ("
About: 1... deploys subt to Azure Virtual Machines (VMs).
About: 2... different VMs run different parts of the system.
About: 4... this includes ugv (ground robot), uav (drone), basestation (gui) and perception (objdet).
About: 5... the different systems run their own gazebo, rviz, etc, but can all communication with each other.
About: 6... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 7... == You Options Are ==
ugv          : deployment subt ugv on azure VMs.
uav          : deployment subt uav on azure VMs.
basestation  : deployment subt basestation on azure VMs.
perception   : deployment subt perception on azure VMs"
);
my $_deployer_azure_ugv_help = ("
About: 1... deploys subt to any one of the remote 'ground robot' Azure VMs.
About: 2... the same deploy is installed on all ground robot VMs.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == You Options Are ==
Options:
ugv1       : deployment subt on ugv1 Azure VM.
ugv2       : deployment subt on ugv2 Azure VM.
ugv3       : deployment subt on ugv3 Azure VM."
);
my $_deployer_azure_uav_help = ("
About: 1... deploys subt to any one of the remote 'drone' Azure VMs.
About: 2... the same deploy is installed on all drone VMs.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == You Options Are ==
uav1       : deployment subt on uav1 Azure VM.
uav2       : deployment subt on uav2 Azure VM.
uav3       : deployment subt on uav3 Azure VM.
uav4       : deployment subt on uav4 Azure VM."
);
# robots
my $_deployer_robots_help = ("
About: 1... deploys subt to one of the remote hardware robots or laptop basestation.
About: 2... different types of robots (and basestation) run different parts of the code.
About: 3... the same deploy is installed on all systems.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == You Options Are ==
basestation  : deployment subt on basestation.
ugv          : deployment subt on ugv hardware robots.
uav          : deployment subt on uav hardware robots."
);
my $_deployer_robots_ugv_help = ("
About: 1... deploys subt to any one of the remote hardware ground robots.
About: 2... the ugvs have 3 different computers, to run different parts of the system.
About: 3... the same deploy is installed on all ground robots.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == You Options Are ==
ugv1       : deployment subt on ugv1 robot.
ugv2       : deployment subt on ugv2 robot.
ugv3       : deployment subt on ugv3 robot."
);
my $_deployer_robots_uav_help = ("
About: 1... deploys subt to any one of the remote hardware drones.
About: 2... the same deploy is installed on all drone robots.
About: 3... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 4... == You Options Are ==
ds1       : deployment subt on ds1 robot.
ds2       : deployment subt on ds2 robot.
ds3       : deployment subt on ds3 robot.
ds4       : deployment subt on ds4 robot."
);
my $_deployer_robots_ugv_computer_help = ("
About: 1... deploys subt to any one of the remote hardware ground robots, to their specific computers.
About: 2... the ugvs have 3 different computers, to run different parts of the system.
About: 3... planning pc (ppc) runs the hardware, planning & comms stack.
About: 4... nuc runs state estimation stack.
About: 5... xavier runs perception stack.
About: 6... all three computers can communication with each other and can reach the basestation.
About: 7... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 8... == You Options Are ==
ppc       : ppc ugv robot computer (hardware, planning, comms).
nuc       : nuc ugv robot computer (state estimation).
xavier    : xavier ugv robot computer (perception)."
);
# general commands
my $_deployer_commands_help = ("
About: 1... general deployment operations commands.
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == You Options Are ==
transfer.to  : transfers code from localhost to remote system (just an rsync).
skel_t.to    : transfers code (slim & faster -- no .git transfer) from localhost to remote system.
docker       : automated docker setup such as containers, images, registry pull.
catkin       : automated catkin build & clean for all catkin profiled workspaces."
);
my $_deployer_commands_docker_help = ("
About: 1... general docker operation commands.
About: 2... you can add -p (preview) to show which deployment commands that will run.
About: 3... you can add -v (verbose) to show the exact shell commands that will be run.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == You Options Are ==
shell                     : starts the docker container on the remote or local system.
rm                        : removes the docker container on the remote or local system.
stop                      : stops the docker container on the remote or local system.
registry.azure.pull       : pulls docker images from the azure registry to the remote or local system (needs internet).
registry.basestation.pull : pulls docker images from the basestation registry to the remote or local system (images need to already exist on the basestation)."
);
my $_deployer_commands_catkin_help = ("
About: 1... general catkin operation commands.
About: 2... you can add -p (preview) to show which deployment commands that will run.
About: 3... you can add -v (verbose) to show the exact shell commands that will be run.
About: 4... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 5... == You Options Are ==
build                     : catkin build (catkin profile workspace already pre-configured).
clean                     : catkin clean (catkin profile workspace already pre-configured)."
);
my $_deployer_localhost_commands_help = ("
About: 1... general deployment operations commands.
About: 2... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)
About: 3... == You Options Are ==
docker       : automated docker setup such as containers, images, registry pull.
catkin       : automated catkin build & clean for all catkin profiled workspaces."
);
# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
my @_help_array = ({
  id      => "local",
  help    => $_deployer_local_help,
},{
  id      => "local.ugv",
  help    => $_deployer_localhost_commands_help,
},{
  id      => "local.uav",
  help    => $_deployer_localhost_commands_help,
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
  help    => $_deployer_commands_catkin_help
});
# @brief covert the array to hashmap
my %_help_hash = map {
  $_->{id} => { help => $_->{help} }
} @_help_array;

# //////////////////////////////////////////////////////////////////////////////
# @brief general tools
# //////////////////////////////////////////////////////////////////////////////

# @brief check string equalities
sub chk_flag {
  my ($_flag, $_args) = @_;
  $_args =~ m/$_flag/ ? return 1 : return 0;
}

# @brief filter unique strings from array
# @reference: https://perldoc.perl.org/perlfaq4.html#How-can-I-remove-duplicate-elements-from-a-list-or-array%3f
sub uniq {
  my %seen;
  my @unique = grep { ! $seen{ $_ }++ } @_;
  return @unique
}

sub remove_trail_dot {
  $_[0]=~ s/\.+$//;
}
sub remove_lead_dot {
  $_[0]=~ s/^\.+//;
}

# //////////////////////////////////////////////////////////////////////////////
# @brief regex functionality
# //////////////////////////////////////////////////////////////////////////////
# @brief match the suffix of the target token (for deployer help tab-complete)
sub help_sregex {
  my ($_target, $_i) = @_;
  $_target =~ qr/(\.[^.]+){$_i}$/;
  return $&;
}
# @brief match the prefix of the target token (for deployer help tab-complete)
sub help_pregex {
  my ($_target, $_i) = @_;
  $_target =~ qr/^([^.].*\.)/;
  return $&;
}

# @brief match the suffix of the target token (for deployer tab-complete)
sub sregex {
  my ($_target,  $_suffix) = @_;
  my $_regex="(?<=^$_target).*";
  $_suffix =~ m/$_regex/;
  return $&;
}

# @brief match the prefix of the target token (for deployer tab-complete)
sub pregex {
  my ($_prefix) = @_;
  my $_regex='^([^\.]+)';
  $_prefix =~ qr/$_regex/;
  return $&;
}

# @brief deployer regex matcher, main entrypoint
sub deploy_matcher {
  my ($_target) = @_, $_result;
  foreach my $_deploy (@_deployer) {
    my $_smatch = sregex($_target, $_deploy);
    if (! $_smatch eq "") {
      my $_pmatch = pregex($_smatch);
      # result:
      # -- given target is partial match, append target to result
      # -- add trailing '.' unless last token -- last token is when suffix & prefix match
      # $_result = $_smatch eq $_pmatch ? "$_result $_target$_pmatch" : "$_result $_target$_pmatch.";
      $_match = $_smatch eq $_pmatch ? "$_target$_pmatch" : "$_target$_pmatch.";
      $_result = "$_result $_match"
    }
  }
  return $_result;
}

# @brief match the deployer help message id with its usage string message
sub find_deployer_help_usage {
  my ($_str) = @_, $_result;
  foreach my $_help (keys %_help_hash) {
    if ( $_help eq $_str ) {
      my $_usage = $_help_hash{$_help}->{help};
      if (! $_usage eq "") { return $_usage; }
    }
  }
  return;
}

# @brief match the deployer help usage message
sub deployer_help_matcher {
  my ($_target) = @_, $_match;
  my $_prefix = help_pregex($_target);  # get the largest prefix (i.e. all tokens before the last '.')
  remove_trail_dot($_prefix);           # remove trailing '.'
  # find the first suffix of given tab-completed token
  my $_dot_counter=1;
  my $_suffix = help_sregex($_prefix, $_dot_counter);
  while ( ! $_suffix eq "" ) {  # get the next suffix, increasing the token by the next suffix
    remove_lead_dot($_suffix);  # remove leading '.'
    # find the help associated with the suffix
    my $_usage = find_deployer_help_usage($_suffix);
    # return help usage message -- if usage message was matched
    if (! $_usage eq "") { return $_usage; }
    # set the next suffix
    $_suffix = help_sregex($_prefix, ++$_dot_counter);
  }
  if ($_prefix eq "") { $_prefix = $_target; }
  return find_deployer_help_usage($_prefix);
}

# @brief match the suffix of the target token
sub gregex {
  my ($_target,  $_str) = @_;
  my $_regex="^$_target.*.*?";
  $_str =~ m/$_regex/;
  return $&;
}

# @brief general matcher (i.e. non deployer commands)
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

} elsif (chk_flag($_func, "git_add")  ) {
  print general_matcher($_target, @_git_add);

} elsif (chk_flag($_func, "git_clone")  ) {
  print general_matcher($_target, @_git_clone);

} elsif (chk_flag($_func, "git_reset")  ) {
  print general_matcher($_target, @_git_reset);

} elsif (chk_flag($_func, "git_clean")  ) {
  print general_matcher($_target, @_git_clean);

} elsif (chk_flag($_func, "git_rm")  ) {
  print general_matcher($_target, @_git_rm);

} elsif (chk_flag($_func, "cloud")  ) {
  print general_matcher($_target, @_cloud);

} elsif (chk_flag($_func, "cloud_terra")  ) {
  print general_matcher($_target, @_cloud_terra);

} elsif (chk_flag($_func, "cloud_ani")  ) {
  print general_matcher($_target, @_cloud_ani);

} elsif (chk_flag($_func, "tools")  ) {
  print general_matcher($_target, @_tools);

} elsif (chk_flag($_func, "deployer") ) {
  my $_match = deploy_matcher($_target);
  # print $_, "\n" for split ' ', "$_match";
  print deploy_matcher($_target);

} elsif (chk_flag($_func, "deployer_help") ) {
  print deployer_help_matcher($_target);
} else {
  print "";  # return empy string on failure
}

