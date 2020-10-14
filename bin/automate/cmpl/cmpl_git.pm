#!/usr/local/bin/perl

package cmpl_deployer;
use Exporter;

# //////////////////////////////////////////////////////////////////////////////
# @brief export modules
# //////////////////////////////////////////////////////////////////////////////

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw(
  @_git_clone
);

# these are exported by default.
our @EXPORT = qw(
  @_git_clone
);

our (
  @_git_clone,
);

# //////////////////////////////////////////////////////////////////////////////
# @brief deployer (git clone) alias as arrays & associated helps
# //////////////////////////////////////////////////////////////////////////////

@_git_clone     = (
"clone.localhost.basestation",
"clone.localhost.common",
"clone.localhost.perception",
"clone.localhost.subt_launch",
"clone.localhost.simulation",
"clone.localhost.ugv.ppc",
"clone.localhost.ugv.nuc",
"clone.localhost.uav.core",
"clone.localhost.uav.hardware",

"clone.basestation.system76.basestation",
"clone.basestation.system76.common",
"clone.basestation.system76.perception",
"clone.basestation.system76.subt_launch",
"clone.basestation.system76.ugv.ppc",
"clone.basestation.system76.ugv.nuc",
"clone.basestation.system76.hardware",
"clone.basestation.system76.uav.core",
"clone.basestation.system76.uav.hardware",
"clone.basestation.system76.simulation",

"clone.basestation.laptop.basestation",
"clone.basestation.laptop.common",
"clone.basestation.laptop.perception",
"clone.basestation.laptop.subt_launch",
"clone.basestation.laptop.uav.core",
"clone.basestation.laptop.uav.hardware",
"clone.basestation.laptop.simulation",

"clone.slam.ugv.slam.devel",
"clone.slam.ugv.slam.robot",
"clone.slam.uav.slam"
);
