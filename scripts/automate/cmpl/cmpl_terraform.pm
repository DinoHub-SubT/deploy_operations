#!/usr/local/bin/perl

package cmpl_terraform;
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
  @_terraform
  @_terraform_help
);

# these are exported by default.
our @EXPORT = qw(
  @_terraform
  @_terraform_help
);

our (
  @_terraform,
  @_terraform_help
);

# read the terraform's cli cmpl matches
@_terraform  = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" , "destroy", "env", "monitor", "list" );

# //////////////////////////////////////////////////////////////////////////////
# @brief various help messages
# //////////////////////////////////////////////////////////////////////////////

# @brief assign help keys to usage messages as hashmap -- hack: convert array to hashmap
# - TODO: update this matcher, to use better regex patterns...
@_terraform_help = ({
  id      => "terraform",
  help    => create_help(get_help(qw(init cert plan apply mkvpn rmvpn start stop destroy monitor env list))),
});

