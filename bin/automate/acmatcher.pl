#!/usr/local/bin/perl

use Cwd qw(abs_path);
use FindBin;
use lib abs_path("$FindBin::Bin/../lib");

use File::Basename;
use lib dirname (__FILE__);

# use deployer qw( @_deployer );  # import listed items
use deployer;

my @_subt         = ( "cloud", "deployer", "git", "tools", "update", "help" );

my @_git          = ( "status", "sync", "add", "clone", "rm", "reset", "clean", "pr", "help" );

my @_git_status   = ( "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

my @_git_sync     = ( "deploy", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

my @_git_add      = ( "basestation", "common", "perception", "simulation", "ugv", "uav", "help" );

my @_git_clone    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "ugv.base", "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam",
                      "uav.hardware", "help");

my @_git_reset    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "ugv.base", "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam",
                      "uav.hardware", "help");

my @_git_clean    = ( "base", "basestation", "common", "perception", "simulation", "subt_launch",
                      "ugv", "uav", "help" );

my @_git_rm       = ( "base", "basestation", "common", "perception", "simulation", "subt_launch", "ugv", "ugv.base",
                      "ugv.hardware", "ugv.slam", "uav", "uav.core", "uav.slam", "uav.hardware", "help");

my @_cloud        = ( "terraform", "ansible", "help" );

my @_cloud_terra  = ( "init", "cert", "plan", "apply", "mkvpn", "rmvpn", "start", "stop" , "destroy",
                      "env", "monitor" );

my @_cloud_ani    = ( "-az", "-r", "-l", "-b", "-p" );

my @_tools        = ( "ssh", "teamviewer", "rdp", "snapshot" );


# @brief covert the array to hashmap
my %_deployer_help_hash = map {
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
  foreach my $_help (keys %_deployer_help_hash) {
    if ( $_help eq $_str ) {
      my $_usage = $_deployer_help_hash{$_help}->{help};
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

